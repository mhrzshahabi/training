package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EducationalDecisionHeaderDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IEducationalDecisionHeaderService;
import com.nicico.training.model.Category;
import com.nicico.training.model.EducationalDecisionHeader;
import com.nicico.training.model.Subcategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.CourseAuditDAO;
import com.nicico.training.repository.EducationalDecisionHeaderDao;
import com.nicico.training.repository.SubcategoryDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.question.dto.ElsCategoryDto;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

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
