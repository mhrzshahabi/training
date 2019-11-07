package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.iservice.IOperationalUnitService;
import com.nicico.training.model.OperationalUnit;
import com.nicico.training.repository.OperationalUnitDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OperationalUnitService implements IOperationalUnitService {

    private final OperationalUnitDAO operationalUnitDAO;
    private final ModelMapper modelMapper;

    //*********************************

    @Transactional(readOnly = true)
    @Override
    public OperationalUnitDTO.Info get(Long id) {
        final Optional<OperationalUnit> optionalOperationalUnit = operationalUnitDAO.findById(id);
        final OperationalUnit operationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return modelMapper.map(operationalUnit, OperationalUnitDTO.Info.class);
    }

    //*********************************

    @Transactional
    @Override
    public List<OperationalUnitDTO.Info> list() {
        List<OperationalUnit> operationalUnitList = operationalUnitDAO.findAll();
        return modelMapper.map(operationalUnitList, new TypeToken<List<OperationalUnitDTO.Info>>() {
        }.getType());
    }

    //*********************************

    @Transactional
    @Override
    public OperationalUnitDTO.Info create(OperationalUnitDTO.Create request) {
        OperationalUnit operationalUnit = modelMapper.map(request, OperationalUnit.class);
        try {
            return modelMapper.map(operationalUnitDAO.saveAndFlush(operationalUnit), OperationalUnitDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }
    }

    //*********************************

    @Transactional
    @Override
    public OperationalUnitDTO.Info update(Long id, OperationalUnitDTO.Update request) {
        Optional<OperationalUnit> optionalOperationalUnit = operationalUnitDAO.findById(id);
        OperationalUnit currentOperationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        OperationalUnit operationalUnit = new OperationalUnit();
        modelMapper.map(currentOperationalUnit, operationalUnit);
        modelMapper.map(request, operationalUnit);

        try {
            return modelMapper.map(operationalUnitDAO.saveAndFlush(operationalUnit), OperationalUnitDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }

    }

    //*********************************

    @Transactional
    @Override
    public void delete(Long id) {
        operationalUnitDAO.deleteById(id);
    }

    //*********************************

    @Transactional
    @Override
    public void delete(OperationalUnitDTO.Delete request) {
        final List<OperationalUnit> operationalUnitList = operationalUnitDAO.findAllById(request.getIds());
        operationalUnitDAO.deleteAll(operationalUnitList);
    }

    //*********************************

    @Transactional
    @Override
    public SearchDTO.SearchRs<OperationalUnitDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalUnitDAO, request, operationalUnit -> modelMapper.map(operationalUnit, OperationalUnitDTO.Info.class));
    }
}
