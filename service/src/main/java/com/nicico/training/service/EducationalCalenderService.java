package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.EducationalCalenderDTO;
import com.nicico.training.iservice.IEducationalCalenderService;
import com.nicico.training.model.EducationalCalender;
import com.nicico.training.repository.EducationalCalenderDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class EducationalCalenderService implements IEducationalCalenderService {

    private final EducationalCalenderDAO educationalCalenderDAO;
    private final ModelMapper mapper;

    @Transactional
    @Override
    public SearchDTO.SearchRs<EducationalCalenderDTO.Info> search(SearchDTO.SearchRq searchRq) {
        return SearchUtil.search(educationalCalenderDAO,
                searchRq, educationalCalender ->mapper.map(educationalCalender, EducationalCalenderDTO.Info.class));
    }
//    @Transactional
    @Override
    public EducationalCalenderDTO create(EducationalCalenderDTO request) {
        final EducationalCalender educationalCalender = mapper.map(request, EducationalCalender.class);

        EducationalCalender ec;

        if (educationalCalender.getId() != null) {
            Optional<EducationalCalender> optionalEducationalCalender = educationalCalenderDAO.findById(educationalCalender.getId());
            if (optionalEducationalCalender.isPresent()) {
                ec = optionalEducationalCalender.get();

                ec.setTitleFa(educationalCalender.getTitleFa());
                ec.setInstituteId(educationalCalender.getInstituteId());
                ec.setStartDate(educationalCalender.getStartDate());
                ec.setEndDate(educationalCalender.getEndDate());
                ec.setCalenderStatus(educationalCalender.getCalenderStatus());
                ec.setCode(educationalCalender.getCode());

                EducationalCalender savedEc = educationalCalenderDAO.save(ec);
                return mapper.map(savedEc, EducationalCalenderDTO.class);
            } else {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
        } else {
            ec = educationalCalenderDAO.save(educationalCalender);
            return mapper.map(ec, EducationalCalenderDTO.class);
        }

    }
    @Transactional
    @Override
    public void delete(Long id) {
        try {
            if (educationalCalenderDAO.existsById(id)) {
                educationalCalenderDAO.deleteById(id);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
}
