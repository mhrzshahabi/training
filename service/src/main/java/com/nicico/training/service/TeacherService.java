package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.IAttachmentService;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

    private final CustomModelMapper modelMapper;
    private final TeacherDAO teacherDAO;
    private final TclassDAO tclassDAO;
    private final CategoryDAO categoryDAO;

    private final IPersonalInfoService personalInfoService;
    private final IAttachmentService attachmentService;
    private final TclassService tclassService;

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
        final Teacher teacher = getTeacher(id);
        teacher.getCategories().clear();
        teacher.getSubCategories().clear();
        Teacher updating = new Teacher();
        personalInfoService.modify(request.getPersonality(), teacher.getPersonality());
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

        SearchDTO.SearchRs<TeacherDTO.Grid> searchRs = SearchUtil.search(teacherDAO, request, needAssessment -> modelMapper.map(needAssessment,
                TeacherDTO.Grid.class));

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
    public void changeBlackListStatus(Boolean inBlackList, Long id) {
        Teacher teacher = getTeacher(id);
        teacher.setInBlackList(!inBlackList);
        teacherDAO.saveAndFlush(teacher);
    }

    @Transactional(readOnly = true)
    public List<TclassDTO.AllStudentsGradeToTeacher> getAllStudentsGradeToTeacher(Long courseId, Long teacherId){
//        List<Tclass> tclassList = tclassDAO.findByCourseIdAndTeacherId(courseId, teacherId);
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
}
