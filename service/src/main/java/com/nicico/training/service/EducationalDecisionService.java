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

        final String ref = educationalDecision.getRef();
        switch (ref) {
            case "base" -> {
                educationalDecision.setItemFromDate(request.getItemFromDate());
                educationalDecision.setItemToDate(request.getItemToDate());
                educationalDecision.setBaseTuitionFee(request.getBaseTuitionFee());
                educationalDecision.setProfessorTuitionFee(request.getProfessorTuitionFee());
                educationalDecision.setKnowledgeAssistantTuitionFee(request.getKnowledgeAssistantTuitionFee());
                educationalDecision.setTeacherAssistantTuitionFee(request.getTeacherAssistantTuitionFee());
                educationalDecision.setInstructorTuitionFee(request.getInstructorTuitionFee());
                educationalDecision.setEducationalAssistantTuitionFee(request.getEducationalAssistantTuitionFee());

            }
            case "history" -> {
                educationalDecision.setItemFromDate(request.getItemFromDate());
                educationalDecision.setItemToDate(request.getItemToDate());
                educationalDecision.setEducationalHistoryFrom(request.getEducationalHistoryFrom());
                educationalDecision.setEducationalHistoryTo(request.getEducationalHistoryTo());

            }
            case "teaching-method" -> {
                educationalDecision.setItemFromDate(request.getItemFromDate());
                educationalDecision.setItemToDate(request.getItemToDate());
                educationalDecision.setTeachingMethod(request.getTeachingMethod());
                educationalDecision.setCourseTypeTeachingMethod(request.getCourseTypeTeachingMethod());
                educationalDecision.setCoefficientOfTeachingMethod(request.getCoefficientOfTeachingMethod());

            }
            case "course-type" -> {
                educationalDecision.setItemFromDate(request.getItemFromDate());
                educationalDecision.setItemToDate(request.getItemToDate());
                educationalDecision.setTypeOfSpecializationCourseType(request.getTypeOfSpecializationCourseType());
                educationalDecision.setCourseLevelCourseType(request.getCourseLevelCourseType());
                educationalDecision.setCourseForCourseType(request.getCourseForCourseType());
                educationalDecision.setCoefficientOfCourseType(request.getCoefficientOfCourseType());

            }
            case "distance" -> {
                educationalDecision.setItemFromDate(request.getItemFromDate());
                educationalDecision.setItemToDate(request.getItemToDate());
                educationalDecision.setDistance(request.getDistance());
                educationalDecision.setResidence(request.getResidence());

            }
        }

/*
        modelMapper.map(request, educationalDecision);
        educationalDecision.setId(id);
        educationalDecisionDao.saveAndFlush(educationalDecision);
//////////////////
        EducationalDecision toUpdate = mapper.toUpdate(educationalDecision,request);
            toUpdate.setId(id);
            EducationalDecision save = educationalDecisionDao.save(toUpdate);
*/

        BaseResponse response = new BaseResponse();
        try {
             response.setStatus(200);
        }catch (Exception e){
            response.setStatus(406);
        }
        return response;
    }
}
