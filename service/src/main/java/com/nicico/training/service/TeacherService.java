package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.Category;
import com.nicico.training.model.EmploymentHistory;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.CategoryDAO;
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
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

    private final CustomModelMapper modelMapper;
    private final TeacherDAO teacherDAO;
    private final CategoryDAO categoryDAO;

    private final IPersonalInfoService personalInfoService;
    private final IAttachmentService attachmentService;
    private final IEmploymentHistoryService employmentHistoryService;

    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;

    @Transactional(readOnly = true)
    @Override
    public TeacherDTO.Info get(Long id) {
        final Optional<Teacher> tById = teacherDAO.findById(id);
        final Teacher teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

        return modelMapper.map(teacher, TeacherDTO.Info.class);
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
        if (byTeacherCode.isPresent())
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);

        request.setPersonalityId(personalInfoService.createOrUpdate(request.getPersonality()).getId());
        request.setPersonality(null);

        final Teacher teacher = modelMapper.map(request, Teacher.class);
        try {
            return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }


    @Transactional
    @Override
    public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {

        Optional<Teacher> optionalTeacher = teacherDAO.findById(id);
        Teacher teacher = optionalTeacher.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        if (request.getPersonality() != null) {
            request.getPersonality().setId(teacher.getPersonalityId());
            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.update(request.getPersonality().getId(), request.getPersonality());
            request.setPersonalityId(personalInfoDTO.getId());
            request.setPersonality(null);
        }

        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);

        if (request.getPersonality() == null)
            updating.setPersonality(null);

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

    // ------------------------------

    @Transactional
    @Override
    public void addCategories(CategoryDTO.Delete request, Long teacherId) {
        final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

        Set<Category> currents = teacher.getCategories();
        if (currents != null) {
            Object[] currentsArr = currents.toArray();
            for (Object o : currentsArr) {
                teacher.getCategories().remove(o);
            }
        }

        List<Category> gAllById = categoryDAO.findAllById(request.getIds());
        for (Category category : gAllById) {
            teacher.getCategories().add(category);
        }
    }

    @Transactional
    @Override
    public void deleteEmploymentHistory(Long teacherId, Long employmentHistoryId) {
        final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        final EmploymentHistoryDTO.Info employmentHistory = employmentHistoryService.get(employmentHistoryId);
        teacher.getEmploymentHistories().remove(modelMapper.map(employmentHistory,EmploymentHistory.class));
        employmentHistory.setTeacherId(null);
    }

    @Transactional
    @Override
    public void addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId) {

        final Optional<Teacher> tById = teacherDAO.findById(teacherId);
        final Teacher teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        EmploymentHistory employmentHistory = new EmploymentHistory();
        modelMapper.map(request, employmentHistory);
        teacher.getEmploymentHistories().add(employmentHistory);
    }

    @Transactional
    @Override
    public List<Long> getCategories(Long teacherId) {
        final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        Set<Category> currents = teacher.getCategories();
        List<Long> categories = new ArrayList<>();
        for (Category current : currents) {
            categories.add(current.getId());
        }
        return categories;
    }

}
