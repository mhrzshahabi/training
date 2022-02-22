package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.iservice.IAcademicBKService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.academicBK.AcademicBKBeanMapper;
import com.nicico.training.model.AcademicBK;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.AcademicBKDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.academicBK.ElsAcademicBKFindAllRespDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AcademicBKService implements IAcademicBKService {

    private final ModelMapper modelMapper;
    private final AcademicBKDAO academicBKDAO;
    private final ITeacherService teacherService;
    private final AcademicBKBeanMapper academicBKBeanMapper;

    @Transactional(readOnly = true)
    @Override
    public AcademicBKDTO.Info get(Long id) {
        return modelMapper.map(getAcademicBK(id), AcademicBKDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public AcademicBK getAcademicBK(Long id) {
        final Optional<AcademicBK> optionalAcademicBK = academicBKDAO.findById(id);
        return optionalAcademicBK.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }


    @Transactional
    @Override
    public AcademicBKDTO.Info update(Long id, AcademicBKDTO.Update request) {
        final AcademicBK academicBK = getAcademicBK(id);
        AcademicBK updating = new AcademicBK();
        modelMapper.map(academicBK, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AcademicBKDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(academicBKDAO, request, academicBK -> modelMapper.map(academicBK, AcademicBKDTO.Info.class));
    }

    private AcademicBKDTO.Info save(AcademicBK academicBK) {
        final AcademicBK saved = academicBKDAO.saveAndFlush(academicBK);
        return modelMapper.map(saved, AcademicBKDTO.Info.class);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    @Transactional
    @Override
    public AcademicBKDTO.Info addAcademicBK(AcademicBKDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        AcademicBK academicBK = modelMapper.map(request, AcademicBK.class);
        AcademicBKDTO.Info info = save(academicBK);
        try {
            teacher.getAcademicBKs().add(academicBK);
            return info;
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void deleteAcademicBK(Long teacherId, Long academicBKId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final AcademicBKDTO.Info academicBK = get(academicBKId);
        try {
            teacher.getAcademicBKs().remove(modelMapper.map(academicBK, AcademicBK.class));
            academicBK.setTeacherId(null);
            academicBKDAO.delete(modelMapper.map(academicBK, AcademicBK.class));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public List<ElsAcademicBKFindAllRespDto> findAcademicBKsByTeacherNationalCode(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<AcademicBK> academicBKList = academicBKDAO.findAllByTeacherId(teacherId);
        return academicBKBeanMapper.academicBKToElsAcademicBKFindAllRes(academicBKList);
    }

}
