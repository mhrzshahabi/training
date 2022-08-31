package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationalDecisionDTO;
import com.nicico.training.iservice.IEducationalDecisionHeaderService;
import com.nicico.training.iservice.IEducationalDecisionService;
import com.nicico.training.mapper.EducationalDecisionMapper.EducationalDecisionMapper;
import com.nicico.training.model.Agreement;
import com.nicico.training.model.EducationalDecision;
import com.nicico.training.model.EducationalDecisionHeader;
import com.nicico.training.repository.EducationalDecisionDao;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import response.BaseResponse;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationalDecisionService implements IEducationalDecisionService {

    private final EducationalDecisionDao educationalDecisionDao;
    private final IEducationalDecisionHeaderService educationalDecisionHeaderService;
    private final EducationalDecisionMapper mapper;
    private final ModelMapper modelMapper;

    @Override
    public EducationalDecisionDTO.Info get(Long id) {
        return null;
    }

    @Override
    public List<EducationalDecision> list(String ref,long header) {
        return educationalDecisionDao.findAllByRefAndEducationalDecisionHeaderId(ref,header);
    }

    @Override
    public BaseResponse create(EducationalDecision request) {
        BaseResponse response=new BaseResponse();
        try {
            educationalDecisionDao.save(request);
            response.setStatus(200);
        }catch (Exception e){
            response.setStatus(406);
        }
    return response;
    }

    @Override
    public void delete(Long id) {
        try {
            if (educationalDecisionDao.existsById(id)) {
                educationalDecisionDao.deleteById(id);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public List<EducationalDecision> findAllByDateAndRef(String fromDate, String ref, String complex) {
        EducationalDecisionHeader educationalDecisionHeader = educationalDecisionHeaderService.findAllByFromDate(fromDate,complex);
        if (educationalDecisionHeader != null) {
            return educationalDecisionDao.findAllByHeaderIdAndFromDateAndRef(educationalDecisionHeader.getId(), fromDate, ref);
        } else
            return new ArrayList<>();
    }

    @Override
    public BaseResponse update(EducationalDecision request,Long id) {

        Optional<EducationalDecision> cById = educationalDecisionDao.findById(id);
        EducationalDecision educationalDecision = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        BaseResponse response = new BaseResponse();

        /*
                Agreement updating = new Agreement();
        modelMapper.map(agreement, updating);
        modelMapper.map(update, updating);
         */

        modelMapper.map(request, educationalDecision);
        educationalDecision.setId(id);
        educationalDecisionDao.saveAndFlush(educationalDecision);

        response.setStatus(200);

//        try {
//
//            EducationalDecision toUpdate = mapper.toUpdate(educationalDecision,request);
//            toUpdate.setId(id);
//            EducationalDecision save = educationalDecisionDao.save(toUpdate);
//            response.setStatus(200);
//        }catch (Exception e){
//            response.setStatus(406);
//        }
        return response;
    }
}
