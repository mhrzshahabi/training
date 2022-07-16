package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationalDecisionHeaderDTO;
import com.nicico.training.iservice.IEducationalDecisionHeaderService;
import com.nicico.training.model.EducationalDecisionHeader;

import com.nicico.training.repository.EducationalDecisionHeaderDao;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import response.BaseResponse;

import java.util.*;

@Service
@RequiredArgsConstructor
public class EducationalDecisionHeaderService implements IEducationalDecisionHeaderService {

    private final EducationalDecisionHeaderDao educationalDecisionHeaderDao;

    @Override
    public EducationalDecisionHeaderDTO.Info get(Long id) {
        return null;
    }

    @Override
    public List<EducationalDecisionHeader> list() {
        return educationalDecisionHeaderDao.findAll();
    }

    @Override
    public BaseResponse create(EducationalDecisionHeader request) {
        BaseResponse response=new BaseResponse();
        try {
            educationalDecisionHeaderDao.save(request);
            response.setStatus(200);
        }catch (Exception e){
            response.setStatus(406);
        }
    return response;
    }

    @Override
    public void delete(Long id) {
        try {
            if (educationalDecisionHeaderDao.existsById(id)) {
                educationalDecisionHeaderDao.deleteById(id);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
}