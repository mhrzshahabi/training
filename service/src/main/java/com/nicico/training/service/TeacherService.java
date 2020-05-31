package com.nicico.training.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

    private final CustomModelMapper modelMapper;
    private final TeacherDAO teacherDAO;
    private final TclassDAO tclassDAO;
    private final IPersonalInfoService personalInfoService;
    private final IAttachmentService attachmentService;
    private final TclassService tclassService;
    private final ICategoryService categoryService;
    private final ISubcategoryService subCategoryService;
    private final ITeacherHelpService teacherHelpService;
    private final IEducationLevelService educationLevelService;
    private final IEducationMajorService educationMajorService;
    private final IEducationOrientationService educationOrientationService;

    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;

    @Transactional(readOnly = true)
    @Override
    public TeacherDTO.Info get(Long id) {
        return modelMapper.map(getTeacher(id), TeacherDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Teacher getTeacher(Long id) {
        final Optional<Teacher> tById = teacherDAO.findById(id);
        return tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public List<TeacherDTO.Info> list() {
        final List<Teacher> tAll = teacherDAO.findAll();

        return modelMapper.map(tAll, new TypeToken<List<TeacherDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public TeacherDTO.Info create(TeacherDTO.Create request) {
        Optional<Teacher> byTeacherCode = teacherDAO.findByTeacherCode(request.getTeacherCode());
        PersonalInfo personalInfo = null;
        if (byTeacherCode.isPresent())
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);

        if (request.getPersonality().getId() != null) {
            personalInfo = personalInfoService.getPersonalInfo(request.getPersonality().getId());
            personalInfoService.modify(request.getPersonality(), personalInfo);
            if(personalInfo.getPhoto() != null)
                request.getPersonality().setPhoto(personalInfo.getPhoto());
            modelMapper.map(request.getPersonality(), personalInfo);
        }
        final Teacher teacher = modelMapper.map(request, Teacher.class);
        if (personalInfo != null)
            teacher.setPersonality(personalInfo);

        try {
            return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {

        PersonalInfo personalInfo = modelMapper.map(personalInfoService.getOneByNationalCode(request.getPersonality().getNationalCode()),PersonalInfo.class);
        final Teacher teacher = getTeacher(id);
        if (personalInfo != null) {
            EducationLevel educationLevel = null;
            EducationMajor educationMajor = null;
            EducationOrientation educationOrientation = null;
            if(request.getPersonality().getEducationLevelId() != null)
                educationLevel = modelMapper.map(educationLevelService.get(request.getPersonality().getEducationLevelId()),EducationLevel.class);
            if(request.getPersonality().getEducationMajorId() != null)
                educationMajor = modelMapper.map(educationMajorService.get(request.getPersonality().getEducationMajorId()),EducationMajor.class);
            if(request.getPersonality().getEducationOrientationId() != null)
                educationOrientation = modelMapper.map(educationOrientationService.get(request.getPersonality().getEducationOrientationId()),EducationOrientation.class);
            personalInfo.setEducationLevel(educationLevel);
            personalInfo.setEducationMajor(educationMajor);
            personalInfo.setEducationOrientation(educationOrientation);
            personalInfoService.modify(request.getPersonality(), personalInfo);
            request.getPersonality().setId(personalInfo.getId());
            request.setPersonalityId(personalInfo.getId());
            teacher.setPersonality(personalInfo);
        }

        teacher.getCategories().clear();
        teacher.getSubCategories().clear();
        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(teacherDAO.saveAndFlush(updating), TeacherDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        List<AttachmentDTO.Info> attachmentInfoList = attachmentService.search(null, "Teacher", id).getList();
        try {
            teacherDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
        for (AttachmentDTO.Info attachment : attachmentInfoList) {
            attachmentService.delete(attachment.getId());
        }
    }

    @Transactional
    @Override
    public void delete(TeacherDTO.Delete request) {
        final List<Teacher> tAllById = teacherDAO.findAllById(request.getIds());
        for (Teacher teacher : tAllById) {
            delete(teacher.getId());
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearch(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.TeacherFullNameTuple.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearchFilter(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.TeacherFullNameTuple.class));
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Info> deepSearch(SearchDTO.SearchRq request) {

        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria("inBlackList", false, EOperator.equals, null);

        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else {
                criteriaRqList.add(criteriaRq);
                request.getCriteria().setCriteria(criteriaRqList);
            }
        } else
            request.setCriteria(criteriaRq);


        SearchDTO.SearchRs<TeacherDTO.Info> searchRs = SearchUtil.search(teacherDAO, request, needAssessment -> modelMapper.map(needAssessment,
                TeacherDTO.Info.class));

        return searchRs;
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request) {

        Page<Teacher> all = teacherDAO.findAll(NICICOSpecification.of(request),NICICOPageable.of(request));
        List<Teacher> listTeacher=all.getContent();

        Long totalCount=all.getTotalElements();

        List<Long> ids = new ArrayList<>();
        int len =listTeacher.size();

        for (int i = 0; i < len; i++) {
            ids.add(listTeacher.get(i).getId());
        }

        request.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));
        request.setStartIndex(null);


        SearchDTO.SearchRs<TeacherDTO.Grid> searchRs = SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher,
                TeacherDTO.Grid.class));
        searchRs.setTotalCount(totalCount);
        return searchRs;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Report> deepSearchReport(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria("inBlackList", false, EOperator.equals, null);

        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else {
                criteriaRqList.add(criteriaRq);
                request.getCriteria().setCriteria(criteriaRqList);
            }
        } else
            request.setCriteria(criteriaRq);

        SearchDTO.SearchRs<TeacherDTO.Report> searchRs = SearchUtil.search(teacherDAO, request, needAssessment -> modelMapper.map(needAssessment,
                TeacherDTO.Report.class));

        searchRs.getList().forEach(x->{
            x.setCodes(x.getTclasse().stream().map(o->o.getTerm().getCode()).distinct().reduce((a,b)->a+","+b).map(Object::toString).orElse(""));
        });

        return searchRs;
    }


    @Override
    public SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    @Override
    public void changeBlackListStatus(String reason, Boolean inBlackList, Long id) {
        Teacher teacher = getTeacher(id);
        teacher.setInBlackList(!inBlackList);
        if (teacher.isInBlackList())
            teacher.setBlackListDescription((reason == null) ? "" : reason);
        else
            teacher.setBlackListDescription("");
        teacherDAO.saveAndFlush(teacher);
    }

    @Transactional(readOnly = true)
    public List<TclassDTO.AllStudentsGradeToTeacher> getAllStudentsGradeToTeacher(Long courseId, Long teacherId) {
        List<Tclass> tclassList = tclassDAO.findByTeacherId(teacherId);
        List<TclassDTO.AllStudentsGradeToTeacher> sendingList = new ArrayList<>();
        for (Tclass tclass : tclassList) {
            TclassDTO.AllStudentsGradeToTeacher tclassDTO = new TclassDTO.AllStudentsGradeToTeacher(tclass.getId(), tclass.getCode(), tclass.getTitleClass(), tclass.getStartDate(),
                    tclass.getEndDate(), tclass.getTerm().getTitleFa(), null);
            tclassDTO.setGrade(String.valueOf(tclassService.getStudentsGradeToTeacher(tclass.getClassStudents())));
            sendingList.add(tclassDTO);
        }
        return sendingList;
    }

    //--------------------------Teacher Basic Evaluation ---------------------------------------------------------------
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> evaluateTeacher(Long teacherId, String catId, String subCatId) {
        Map<String, Object> resultSet = new HashMap<>();
        float evaluationGrade = 0;
        boolean pass = false;
        String pass_status = "";
        float table_1_grade = 0;
        float table_1_license = 0;
        float table_1_work = 0;
        float table_1_related_training = 0;
        float table_1_unRelated_training = 0;
        float table_1_courses = 0;
        float table_1_years = 0;
        float table_1_related_training_hours = 0;
        float table_1_unRelated_training_hours = 0;
        float table_2_grade = 0;
        float table_3_grade = 0;
        float table_3_count_book = 0;
        float table_3_count_project = 0;
        float table_3_count_article = 0;
        float table_3_count_translation = 0;
        float table_3_count_note = 0;
        float table_4_grade = 0;

        Long CatId = null;
        Long SubCatId = null;
        Category category_selected = null;
        Subcategory subCategory_selected = null;
        if (!catId.equalsIgnoreCase("undefined")) {
            CatId = Long.parseLong(catId);
            category_selected = modelMapper.map(categoryService.get(CatId), Category.class);
        }
        if (!subCatId.equalsIgnoreCase("undefined")) {
            SubCatId = Long.parseLong(subCatId);
            subCategory_selected = modelMapper.map(subCategoryService.get(SubCatId), Subcategory.class);
        }
        TeacherDTO.Info teacherDTO = get(teacherId);
        Teacher teacher = modelMapper.map(teacherDTO, Teacher.class);
        int teacher_educationLevel = 1;

        if(teacher.getPersonality().getEducationLevel().getCode() != null)
                teacher_educationLevel = teacher.getPersonality().getEducationLevel().getCode();
//        if (teacher.getPersonality().getEducationLevel().getTitleFa().equalsIgnoreCase("دیپلم"))
//            teacher_educationLevel = 1;
//        else if (teacher.getPersonality().getEducationLevel().getTitleFa().equalsIgnoreCase("فوق دیپلم"))
//            teacher_educationLevel = 2;
//        else if (teacher.getPersonality().getEducationLevel().getTitleFa().equalsIgnoreCase("لیسانس"))
//            teacher_educationLevel = 3;
//        else if (teacher.getPersonality().getEducationLevel().getTitleFa().equalsIgnoreCase("فوق لیسانس"))
//            teacher_educationLevel = 4;
//        else if (teacher.getPersonality().getEducationLevel().getTitleFa().contains("دکتر"))
//            teacher_educationLevel = 5;

        //table 1
        //table 1 - row 1
        table_1_license = (teacher_educationLevel - 1) * 5 + 10;
        //table 1 - row 2
        List<EmploymentHistoryDTO.Info> employmentHistories = teacherHelpService.getEmploymentHistories(teacherId);

        if (employmentHistories != null) {
            for (EmploymentHistoryDTO.Info employmentHistory : employmentHistories) {
                boolean cat_related = false;
                boolean subCat_related = false;
                List<CategoryDTO.CategoryInfoTuple> employmentHistory_catrgories = employmentHistory.getCategories();
                for (CategoryDTO.CategoryInfoTuple employmentHistory_catrgory : employmentHistory_catrgories) {
                    if (employmentHistory_catrgory.getId() == category_selected.getId())
                        cat_related = true;
                }
                if (cat_related == true) {
                    List<SubcategoryDTO.SubCategoryInfoTuple> employmentHistory_sub_catrgories = employmentHistory.getSubCategories();
                    for (SubcategoryDTO.SubCategoryInfoTuple employmentHistory_sub_catrgory : employmentHistory_sub_catrgories) {
                        if (employmentHistory_sub_catrgory.getId() == subCategory_selected.getId())
                            subCat_related = true;
                    }
                }
                if (cat_related && subCat_related) {
                    if (employmentHistory.getEndDate() != null && employmentHistory.getStartDate() != null) {
                        Long years = Long.parseLong(employmentHistory.getEndDate().substring(0, 4)) -
                                Long.parseLong(employmentHistory.getStartDate().substring(0, 4)) + 1;
                        table_1_work += years;
                    }
                }
                if (employmentHistory.getEndDate() != null && employmentHistory.getStartDate() != null) {
                    Long years = Long.parseLong(employmentHistory.getEndDate().substring(0, 4)) -
                            Long.parseLong(employmentHistory.getStartDate().substring(0, 4)) + 1;
                    table_1_years += years;
                }
            }
        }
        if (table_1_work > 10)
            table_1_work = 10;
        Double table_1_work_double = ((teacher_educationLevel - 1) * 0.2 + 0.6) * table_1_work;
        table_1_work = table_1_work_double.floatValue();
        //table 1 - row 3 & 4
        List<TeachingHistoryDTO.Info> teachingHistories = teacherHelpService.getTeachingHistories(teacherId);

        for (TeachingHistoryDTO.Info teachingHistory : teachingHistories) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> teachingHistory_catrgories = teachingHistory.getCategories();
            for (CategoryDTO.CategoryInfoTuple teachingHistory_catrgory : teachingHistory_catrgories) {
                if (teachingHistory_catrgory.getId() == category_selected.getId())
                    cat_related = true;
            }
            if (cat_related == true) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teachingHistory_sub_catrgories = teachingHistory.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teachingHistory_sub_catrgory : teachingHistory_sub_catrgories) {
                    if (teachingHistory_sub_catrgory.getId() == subCategory_selected.getId())
                        subCat_related = true;
                }
            }
            if (cat_related && subCat_related) {
                if (teachingHistory.getDuration() != null) {
                    table_1_related_training += teachingHistory.getDuration();
                    table_1_related_training_hours += teachingHistory.getDuration();
                }
            } else {
                if (teachingHistory.getDuration() != null) {
                    table_1_unRelated_training += teachingHistory.getDuration();
                    table_1_unRelated_training_hours += teachingHistory.getDuration();
                }
            }

        }
        if (table_1_unRelated_training > 1000)
            table_1_unRelated_training = 1000;
        if (table_1_related_training > 1000)
            table_1_related_training = 1000;
        table_1_related_training /= 100;
        table_1_unRelated_training /= 100;

        Double table_1_unRelated_training_double = ((teacher_educationLevel - 1) * 0.1 + 0.4) * table_1_unRelated_training;
        table_1_unRelated_training = table_1_unRelated_training_double.floatValue();
        Double table_1_related_training_double = ((teacher_educationLevel - 1) * 0.5 + 2) * table_1_related_training;
        table_1_related_training = table_1_related_training_double.floatValue();
        //table 1 - row 5
        List<TeacherCertificationDTO.Info> teacherCertifications = teacherHelpService.getTeacherCertifications(teacherId);

        for (TeacherCertificationDTO.Info teacherCertification : teacherCertifications) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> teacherCertification_catrgories = teacherCertification.getCategories();
            for (CategoryDTO.CategoryInfoTuple teacherCertification_catrgory : teacherCertification_catrgories) {
                if (teacherCertification_catrgory.getId() == category_selected.getId())
                    cat_related = true;
            }
            if (cat_related == true) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teacherCertification_sub_catrgories = teacherCertification.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teacherCertification_sub_catrgory : teacherCertification_sub_catrgories) {
                    if (teacherCertification_sub_catrgory.getId() == subCategory_selected.getId())
                        subCat_related = true;
                }
            }
            if (cat_related && subCat_related) {
                if (teacherCertification.getDuration() != null)
                    table_1_courses += teacherCertification.getDuration();
            }
        }
        if (table_1_courses > 1000)
            table_1_courses = 1000;
        table_1_courses /= 100;

        if (teacher_educationLevel != 1) {
            Double table_1_courses_double = ((teacher_educationLevel - 1) * 0.1 + 1.2) * table_1_courses;
            table_1_courses = table_1_courses_double.floatValue();
        }
        //table 1 - total
        table_1_grade = table_1_courses +
                table_1_license +
                table_1_related_training +
                table_1_unRelated_training +
                table_1_work;

        //table 2
        int table_2_relation = 0;
        Category teacherMajorCategory = teacher.getMajorCategory();
        Subcategory teacherMajorSubCategory = teacher.getMajorSubCategory();
        if (teacherMajorCategory != null) {
            if (category_selected.getId() == teacherMajorCategory.getId()) {
                table_2_relation += 1;
                if (subCategory_selected != null && teacherMajorSubCategory != null)
                    if (subCategory_selected.getId() == teacherMajorSubCategory.getId())
                        table_2_relation += 1;
            }
        }
        if (teacher_educationLevel == 1)
            table_2_grade = (float) 2.5;
        else if (teacher_educationLevel == 2)
            table_2_grade = 6;
        else if (teacher_educationLevel == 3)
            table_2_grade = 8;
        else if (teacher_educationLevel == 4)
            table_2_grade = 9;
        else if (teacher_educationLevel == 5)
            table_2_grade = 10;

        table_2_grade *= table_2_relation;

        //table 3
        List<PublicationDTO.Info> publications = teacherHelpService.getPublications(teacherId);

        for (PublicationDTO.Info publication : publications) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> publication_catrgories = publication.getCategories();
            for (CategoryDTO.CategoryInfoTuple publication_catrgory : publication_catrgories) {
                if (publication_catrgory.getId() == category_selected.getId())
                    cat_related = true;
            }
            if (cat_related == true) {
                List<SubcategoryDTO.SubCategoryInfoTuple> publication_sub_catrgories = publication.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple publication_sub_catrgory : publication_sub_catrgories) {
                    if (publication_sub_catrgory.getId() == subCategory_selected.getId())
                        subCat_related = true;
                }
            }
            if (cat_related && subCat_related) {
                if (publication.getPublicationSubjectTypeId() == 0)
                    table_3_count_book += 1;
                if (publication.getPublicationSubjectTypeId() == 1)
                    table_3_count_project += 1;
                if (publication.getPublicationSubjectTypeId() == 2)
                    table_3_count_article += 1;
                if (publication.getPublicationSubjectTypeId() == 3)
                    table_3_count_translation += 1;
                if (publication.getPublicationSubjectTypeId() == 4)
                    table_3_count_note += 1;
            }
        }
        if (table_3_count_book > 10)
            table_3_count_book = 10;
        if (table_3_count_project > 10)
            table_3_count_project = 10;
        if (table_3_count_article > 10)
            table_3_count_article = 10;
        if (table_3_count_note > 10)
            table_3_count_note = 10;
        if (table_3_count_translation > 10)
            table_3_count_translation = 10;

        table_3_grade = table_3_count_book * 7
                + table_3_count_project * 4
                + table_3_count_article * 3
                + table_3_count_translation * 2
                + table_3_count_note;
        //table 4
        List<ForeignLangKnowledgeDTO.Info> foreignLangKnowledges = teacherHelpService.getForeignLangKnowledges(teacherId);

        for (ForeignLangKnowledgeDTO.Info foreignLangKnowledge : foreignLangKnowledges) {
            if (foreignLangKnowledge.getLangName().equalsIgnoreCase("انگلیسی") || foreignLangKnowledge.getLangName().equalsIgnoreCase("زبان انگلیسی")) {
                if (foreignLangKnowledge.getLangLevelId() == 0)
                    table_4_grade = 3;
                else if (foreignLangKnowledge.getLangLevelId() == 1)
                    table_4_grade = 2;
                else if (foreignLangKnowledge.getLangLevelId() == 2)
                    table_4_grade = 1;
            }
        }
        //total grade
        evaluationGrade = table_1_grade + table_2_grade + table_3_grade + table_4_grade;
        if (teacher_educationLevel == 1) {
            if (evaluationGrade >= 25)
                pass = true;
        } else if (teacher_educationLevel == 2) {
            if (evaluationGrade >= 40)
                pass = true;
        } else if (teacher_educationLevel == 3) {
            if (evaluationGrade >= 55)
                pass = true;
        } else if (teacher_educationLevel == 4) {
            if (evaluationGrade >= 60)
                pass = true;
        } else if (teacher_educationLevel == 5) {
            if (evaluationGrade >= 75)
                pass = true;
        }

        if (pass)
            pass_status = "قبول";
        if (!pass)
            pass_status = "رد";

        resultSet.put("evaluationGrade", evaluationGrade);
        resultSet.put("pass_status", pass_status);
        resultSet.put("table_1_grade", table_1_grade);
        resultSet.put("table_1_license", table_1_license);
        resultSet.put("table_1_work", table_1_work);
        resultSet.put("table_1_related_training", table_1_related_training);
        resultSet.put("table_1_unRelated_training", table_1_unRelated_training);
        resultSet.put("table_1_courses", table_1_courses);
        resultSet.put("table_1_years", table_1_years);
        resultSet.put("table_1_related_training_hours", table_1_related_training_hours);
        resultSet.put("table_1_unRelated_training_hours", table_1_unRelated_training_hours);
        resultSet.put("table_2_grade", table_2_grade);
        resultSet.put("table_3_grade", table_3_grade);
        resultSet.put("table_3_count_book", table_3_count_book);
        resultSet.put("table_3_count_project", table_3_count_project);
        resultSet.put("table_3_count_article", table_3_count_article);
        resultSet.put("table_3_count_translation", table_3_count_translation);
        resultSet.put("table_3_count_note", table_3_count_note);
        resultSet.put("table_4_grade", table_4_grade);
        return resultSet;
    }
}
