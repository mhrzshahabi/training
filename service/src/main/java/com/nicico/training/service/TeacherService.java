package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Category;
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
    private final PersonalInfoService personalInfoService;


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
            return modelMapper.map(teacherDAO.save(teacher), TeacherDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }


    @Transactional
    @Override
    public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {

        if (request.getPersonality() != null) {
            PersonalInfoDTO.Info personalInfoDTO = personalInfoService.update(request.getPersonality().getId(), request.getPersonality());
            request.setPersonalityId(personalInfoDTO.getId());
            request.setPersonality(null);
        }

        Optional<Teacher> optionalTeacher = teacherDAO.findById(id);
        Teacher teacher = optionalTeacher.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);

        if (request.getPersonality() == null)
            updating.setPersonality(null);

        try {
            return modelMapper.map(teacherDAO.save(updating), TeacherDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            teacherDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(TeacherDTO.Delete request) {
        final List<Teacher> tAllById = teacherDAO.findAllById(request.getIds());
        teacherDAO.deleteAll(tAllById);
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
