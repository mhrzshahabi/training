package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.teacher.TeacherBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.teacher.dto.TeacherInCourseDto;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Calendar;

import static com.nicico.training.utility.persianDate.MyUtils.checkEmailFormat;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

    private final CustomModelMapper modelMapper;
    private final TeacherBeanMapper teacherBeanMapper;
    private final TeacherDAO teacherDAO;
    private final TclassDAO tclassDAO;
    private final ParameterService parameterService;
    private final IPersonalInfoService personalInfoService;
    private final IAttachmentService attachmentService;
    private final TclassService tclassService;
    private final ICategoryService categoryService;
    private final ISubcategoryService subCategoryService;
    private final ITeacherHelpService teacherHelpService;
    private final IEducationLevelService educationLevelService;
    private final IEducationMajorService educationMajorService;
    private final IEducationOrientationService educationOrientationService;
    private final ITeacherRoleService iTeacherRoleService;
    private final IPersonalInfoService iPersonalInfoService;
    private final ComplexDAO complexDAO;


    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;

    @Transactional(readOnly = true)
    @Override
    public TeacherDTO.Info get(Long id) {
        Set<TeacherExperienceInfoDTO> finalDTOs=new HashSet<>();
        TeacherDTO.Info info= modelMapper.map(getTeacher(id), TeacherDTO.Info.class);
//
//        if(info.getTeacherExperienceInfo()!=null && info.getTeacherExperienceInfo().size()>0){
//            info.getTeacherExperienceInfos().stream().forEach(teacherExperienceInfoDTO -> {
//                String persianDate=  PersianDate.convertToTrainingPersianDate(teacherExperienceInfoDTO.getCreatedDate());
//              teacherExperienceInfoDTO.setCreatedDatePersian(persianDate);
//               finalDTOs.add(teacherExperienceInfoDTO);
//
//            });
////          info.setTeacherExperienceInfos(finalDTOs);
//        }
        return info;
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
        PersonalInfo personalInfo = modelMapper.map(personalInfoService.get(request.getPersonality().getId()),PersonalInfo.class);
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
        teacher.getComplexes().clear();
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
        List<Role> roleList = iTeacherRoleService.findAllRoleByTeacherId(id);
        try {
            String nationalCode = getTeacherNationalCodeById(id);
            for (AttachmentDTO.Info attachment : attachmentInfoList) {
                attachmentService.delete(attachment.getId());
            }
            for (Role role : roleList) {
                iTeacherRoleService.removeTeacherRole(nationalCode, role.getId());
            }
            teacherDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
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
    public SearchDTO.SearchRs<TeacherDTO.TeacherInfoTuple> infoTupleSearch(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.TeacherInfoTuple.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearchFilter(SearchDTO.SearchRq request) {
        return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.TeacherFullNameTuple.class));
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Info> deepSearch(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {

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


        SearchDTO.SearchRs<TeacherDTO.Info> searchRs = BaseService.<Teacher, TeacherDTO.Info, TeacherDAO>optimizedSearch(teacherDAO, p->modelMapper.map(p, TeacherDTO.Info.class), request);

        return searchRs;
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria("inBlackList", false, EOperator.equals, null);

        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        if (request.getCriteria() != null) {

             for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
                 if (o.getFieldName().equalsIgnoreCase("complexId"))
                 {
                     o.setFieldName("complexes");
                  }
             }

            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else {
                criteriaRqList.add(criteriaRq);
                request.getCriteria().setCriteria(criteriaRqList);
            }
        } else
            request.setCriteria(criteriaRq);


        SearchDTO.SearchRs<TeacherDTO.Grid> searchRs = BaseService.<Teacher, TeacherDTO.Grid, TeacherDAO>optimizedSearch(teacherDAO, p->modelMapper.map(p, TeacherDTO.Grid.class), request);
        for (TeacherDTO.Grid teacher: searchRs.getList()) {
            String lastClassDate = tclassDAO.findLastTeacherClassStartDate(teacher.getId());
            teacher.setLastClass(lastClassDate);
        }

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

        SearchDTO.SearchRs<TeacherDTO.Report> searchRs = SearchUtil.search(teacherDAO, request, tclass -> modelMapper.map(tclass, TeacherDTO.Report.class));

        searchRs.getList().forEach(x->{
            x.setCodes(x.getTclasse().stream().map(o->o.getTerm().getCode()).distinct().reduce((a,b)->a+","+b).map(Object::toString).orElse(""));
        });

        return searchRs;
    }


    @Override
    public SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
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

    @Override
    public Optional<Teacher> findByTeacherCode(String teacherCode) {
        return teacherDAO.findByTeacherCode(teacherCode);
    }

    @Override
    public String getTeacherFullName(Long teacherId) {
        return teacherDAO.getTeacherFullName(teacherId);
    }

    @Override
    public BaseResponse saveElsTeacherGeneralInfo(Teacher teacher, TeacherGeneralInfoDTO teacherGeneralInfoDTO) {
        BaseResponse baseResponse = new BaseResponse();
        if (teacher != null) {
            PersonalInfo teacherPersonalInfo = iPersonalInfoService.getPersonalInfo(teacher.getPersonalityId());
            ContactInfo contactInfo = teacherPersonalInfo.getContactInfo();
            if (teacherGeneralInfoDTO.getBirthDate() != null && teacherGeneralInfoDTO.getBirthDate() != 0) {
                long time = teacherGeneralInfoDTO.getBirthDate();
                Date date = new Date(time);
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(date);
                calendar.add(Calendar.HOUR_OF_DAY, 4);
                calendar.add(Calendar.MINUTE, 30);
                date = calendar.getTime();
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String birtDate = DateUtil.convertMiToKh(dateFormat.format(date));
                teacherPersonalInfo.setBirthDate(birtDate);
            } else {
                teacherPersonalInfo.setBirthDate(null);
            }
            if (teacherGeneralInfoDTO.getEmail() != null && teacherGeneralInfoDTO.getEmail() != "") {

                if (checkEmailFormat(teacherGeneralInfoDTO.getEmail())) {
                    contactInfo.setEmail(teacherGeneralInfoDTO.getEmail());
                } else {
                    baseResponse.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    baseResponse.setMessage("فرمت ایمیل نادرست است");
                    return baseResponse;
                }

            } else {
                contactInfo.setEmail(null);
            }
            if (teacherGeneralInfoDTO.getIban() != null && teacherGeneralInfoDTO.getIban() != "") {
                if (teacherGeneralInfoDTO.getIban().length() == 24 && teacherGeneralInfoDTO.getIban().matches("\\d+")) {
                    teacher.setIban(teacherGeneralInfoDTO.getIban());
                } else {
                    baseResponse.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    baseResponse.setMessage("مقداز شماره شبا باید دارای ۲۴ رقم و بصورت عددی بدون IR وارد کنید");
                    return baseResponse;
                }
            } else {
                teacher.setIban(null);
            }
            teacher.setTeachingBackground(teacherGeneralInfoDTO.getTeachingBackground());
            teacherPersonalInfo.setContactInfo(contactInfo);
            teacher.setPersonality(teacherPersonalInfo);
            teacherDAO.save(teacher);
            baseResponse.setStatus(200);
        } else {
            baseResponse.setStatus(HttpStatus.NO_CONTENT.value());
            baseResponse.setMessage("استادی با این اطلاعات یافت نشد");
        }
        return baseResponse;
    }

    @Override
    @Transactional
    public ElsTeacherInfoDto.Resume getTeacherResumeByNationalCode(String nationalCode) {
        ElsTeacherInfoDto.Resume resume = new ElsTeacherInfoDto.Resume();
        try {
            Long teacherId = getTeacherIdByNationalCode(nationalCode);
            Teacher teacher = getTeacher(teacherId);
            resume = teacherBeanMapper.toElsTeacherResumeDto(teacher);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return resume;
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

        if(teacher.getPersonality().getEducationLevel() != null && teacher.getPersonality().getEducationLevel().getCode() != null)
                teacher_educationLevel = teacher.getPersonality().getEducationLevel().getCode();

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
                    if (employmentHistory_catrgory.getId().equals(category_selected.getId()))
                        cat_related = true;
                }
                if (cat_related) {
                    List<SubcategoryDTO.SubCategoryInfoTuple> employmentHistory_sub_catrgories = employmentHistory.getSubCategories();
                    for (SubcategoryDTO.SubCategoryInfoTuple employmentHistory_sub_catrgory : employmentHistory_sub_catrgories) {
                        if (employmentHistory_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
                if (teachingHistory_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teachingHistory_sub_catrgories = teachingHistory.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teachingHistory_sub_catrgory : teachingHistory_sub_catrgories) {
                    if (teachingHistory_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
                if (teacherCertification_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teacherCertification_sub_catrgories = teacherCertification.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teacherCertification_sub_catrgory : teacherCertification_sub_catrgories) {
                    if (teacherCertification_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
            if (category_selected.getId().equals(teacherMajorCategory.getId())) {
                table_2_relation += 1;
                if (subCategory_selected != null && teacherMajorSubCategory != null)
                    if (subCategory_selected.getId().equals(teacherMajorSubCategory.getId()))
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
                if (publication_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> publication_sub_catrgories = publication.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple publication_sub_catrgory : publication_sub_catrgories) {
                    if (publication_sub_catrgory.getId().equals(subCategory_selected.getId()))
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

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();

        if (teacher_educationLevel == 1) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankDiploma")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 2) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankAD")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 3) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankBachelor")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 4) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankMaster")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 5) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankPhd")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
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
        resultSet.put("minEvaluationGrade1",Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankDiploma")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()));
        resultSet.put("minEvaluationGrade2",Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankAD")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()));
        resultSet.put("minEvaluationGrade3",Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankBachelor")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()));
        resultSet.put("minEvaluationGrade4",Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankMaster")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()));
        resultSet.put("minEvaluationGrade5",Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankPhd")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()));
        return resultSet;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> evaluateTeacher(Teacher teacher, Category category, Subcategory subcategory,List<ParameterValueDTO.Info> parameterValues) {
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

        Category category_selected = category;
        Subcategory subCategory_selected = subcategory;

        int teacher_educationLevel = 1;

        if (teacher.getPersonality().getEducationLevel() != null && teacher.getPersonality().getEducationLevel().getCode() != null)
            teacher_educationLevel = teacher.getPersonality().getEducationLevel().getCode();

        //table 1
        //table 1 - row 1
        table_1_license = (teacher_educationLevel - 1) * 5 + 10;
        //table 1 - row 2
        List<EmploymentHistoryDTO.Info> employmentHistories = modelMapper.map(teacher.getEmploymentHistories(), new TypeToken<List<EmploymentHistoryDTO.Info>>() {
        }.getType());

        if (employmentHistories != null) {
            for (EmploymentHistoryDTO.Info employmentHistory : employmentHistories) {
                boolean cat_related = false;
                boolean subCat_related = false;
                List<CategoryDTO.CategoryInfoTuple> employmentHistory_catrgories = employmentHistory.getCategories();
                for (CategoryDTO.CategoryInfoTuple employmentHistory_catrgory : employmentHistory_catrgories) {
                    if (employmentHistory_catrgory.getId().equals(category_selected.getId()))
                        cat_related = true;
                }
                if (cat_related) {
                    List<SubcategoryDTO.SubCategoryInfoTuple> employmentHistory_sub_catrgories = employmentHistory.getSubCategories();
                    for (SubcategoryDTO.SubCategoryInfoTuple employmentHistory_sub_catrgory : employmentHistory_sub_catrgories) {
                        if (employmentHistory_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
        List<TeachingHistoryDTO.Info> teachingHistories = modelMapper.map(teacher.getTeachingHistories(), new TypeToken<List<TeachingHistoryDTO.Info>>() {
        }.getType());

        for (TeachingHistoryDTO.Info teachingHistory : teachingHistories) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> teachingHistory_catrgories = teachingHistory.getCategories();
            for (CategoryDTO.CategoryInfoTuple teachingHistory_catrgory : teachingHistory_catrgories) {
                if (teachingHistory_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teachingHistory_sub_catrgories = teachingHistory.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teachingHistory_sub_catrgory : teachingHistory_sub_catrgories) {
                    if (teachingHistory_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
        List<TeacherCertificationDTO.Info> teacherCertifications = modelMapper.map(teacher.getTeacherCertifications(), new TypeToken<List<TeacherCertificationDTO.Info>>() {
        }.getType());

        for (TeacherCertificationDTO.Info teacherCertification : teacherCertifications) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> teacherCertification_catrgories = teacherCertification.getCategories();
            for (CategoryDTO.CategoryInfoTuple teacherCertification_catrgory : teacherCertification_catrgories) {
                if (teacherCertification_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> teacherCertification_sub_catrgories = teacherCertification.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple teacherCertification_sub_catrgory : teacherCertification_sub_catrgories) {
                    if (teacherCertification_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
            if (category_selected.getId().equals(teacherMajorCategory.getId())) {
                table_2_relation += 1;
                if (subCategory_selected != null && teacherMajorSubCategory != null)
                    if (subCategory_selected.getId().equals(teacherMajorSubCategory.getId()))
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
        List<PublicationDTO.Info> publications = modelMapper.map(teacher.getPublications(), new TypeToken<List<PublicationDTO.Info>>() {
        }.getType());

        for (PublicationDTO.Info publication : publications) {
            boolean cat_related = false;
            boolean subCat_related = false;
            List<CategoryDTO.CategoryInfoTuple> publication_catrgories = publication.getCategories();
            for (CategoryDTO.CategoryInfoTuple publication_catrgory : publication_catrgories) {
                if (publication_catrgory.getId().equals(category_selected.getId()))
                    cat_related = true;
            }
            if (cat_related) {
                List<SubcategoryDTO.SubCategoryInfoTuple> publication_sub_catrgories = publication.getSubCategories();
                for (SubcategoryDTO.SubCategoryInfoTuple publication_sub_catrgory : publication_sub_catrgories) {
                    if (publication_sub_catrgory.getId().equals(subCategory_selected.getId()))
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
        List<ForeignLangKnowledgeDTO.Info> foreignLangKnowledges = modelMapper.map(teacher.getForeignLangKnowledges(), new TypeToken<List<ForeignLangKnowledgeDTO.Info>>() {
        }.getType());

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
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankDiploma")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()) )
                pass = true;
        } else if (teacher_educationLevel == 2) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankAD")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 3) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankBachelor")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 4) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankMaster")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
                pass = true;
        } else if (teacher_educationLevel == 5) {
            if (evaluationGrade >= Integer.parseInt(parameterValues.stream().filter(p -> p.getCode().equals("MinTeacherEvalRankPhd")).findFirst().orElse((ParameterValueDTO.Info) (new ParameterValueDTO.Info()).setValue("100")).getValue()))
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

    @Transactional(readOnly = true)
    public List<TeacherInCourseDto> getTeachersInCourse(Long courseId){
        List<Teacher> teachers = teacherDAO.findDistinctByTclasseCourseId(courseId);
        return teacherBeanMapper.toTeacherInCourseDtoList(teachers);
    }

    @Transactional
    @Override
    public Long getTeacherIdByNationalCode(String nationalCode) {
        return teacherDAO.getTeacherId(nationalCode);
    }

    @Override
    public Teacher getTeacherByNationalCode(String nationalCode) {
        return teacherDAO.getTeacherByNationalCode(nationalCode);
    }

    @Override
    public Page<Teacher> getActiveTeachers(int page, int size) {
        Pageable pageable= PageRequest.of(page,size, Sort.by(
                Sort.Order.asc("id")));

        Page<Teacher> activeTeachers= teacherDAO.findAllActiveTeacher(pageable);
     return activeTeachers;
    }

    @Transactional
    public String getTeacherNationalCodeById(Long teacherId) {
        return teacherDAO.getTeacherNationalCode(teacherId);
    }

    @Override
    public List<Map<String, Object>> findAllByNationalCodeAndMobileNumber(String nationalCode, String mobileNumber) {
        return teacherDAO.findAllByNationalCodeAndMobileNumber(mobileNumber,nationalCode);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.ForAgreementInfo> forAgreementInfoSearch(SearchDTO.SearchRq request) {

        SearchDTO.SearchRs<TeacherDTO.ForAgreementInfo> infoSearchRs = SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.ForAgreementInfo.class));
        for (TeacherDTO.ForAgreementInfo agreementInfo : infoSearchRs.getList()) {
            if (agreementInfo.getPersonality() == null || agreementInfo.getPersonality().getFirstNameFa() == null || agreementInfo.getPersonality().getLastNameFa() == null ||
                    agreementInfo.getPersonality().getNationalCode() == null || agreementInfo.getPersonality().getContactInfo() == null || agreementInfo.getPersonality().getContactInfo().getMobile() == null ||
                    agreementInfo.getPersonality().getContactInfo().getHomeAddress() == null || agreementInfo.getPersonality().getAccountInfo() == null || agreementInfo.getPersonality().getAccountInfo().getShabaNumber() == null) {
                agreementInfo.setValid(false);
            } else agreementInfo.setValid(true);
        }
        return infoSearchRs;
    }

    @Override
    public String getTeacherResidence(Long teacherId) {
        return teacherDAO.getTeacherResidence(teacherId);
    }

    @Override
    public boolean changeTeacherPersonnel(long id, String personnel_code) {
        Optional<Teacher> optionalTeacher = teacherDAO.findById(id);
        if (optionalTeacher.isPresent()){
            Teacher teacher= optionalTeacher.get();
            teacher.setPersonnelStatus(true);
            teacher.setPersonnelCode(personnel_code);
            teacherDAO.save(teacher);
        }
        return false;
    }

    @Override
    public List<TeacherDTO.TeacherComplex> addTeacherComplexesList(List<TeacherDTO.TeacherComplex> createList) {
        List<TeacherDTO.TeacherComplex> returnTeacherList = new ArrayList<>();

        createList.forEach(create -> {
            if (create.getNationalCode() != null && create.getComplex() != null) {
                Teacher teacher = teacherDAO.getTeacherByNationalCode(create.getNationalCode());

                if (teacher != null) {
                    Long complexId = complexDAO.getComplexIdByComplexTitle(create.getComplex());

                    if (complexId != null) {
                        Optional<Teacher> teacherWithComplexes = teacherDAO.getTeacherById(teacher.getId());

                         if (teacherWithComplexes.isPresent()) {
                             Set<Long> complexes = teacherWithComplexes.get().getComplexes();
                             complexes.add(complexId);
                             teacher.setComplexes(complexes);
                             teacherDAO.save(teacher);
                         }
                    }

                } else
                    returnTeacherList.add(create);
            } else
                returnTeacherList.add(create);
        });
        return returnTeacherList;
    }
}
