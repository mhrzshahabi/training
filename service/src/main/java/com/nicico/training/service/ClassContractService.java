package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassContract;
import com.nicico.training.repository.ClassContractDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class ClassContractService implements IClassContractService {

    private final ClassContractDAO classContractDAO;
    private final ModelMapper mapper;


    @Transactional(readOnly = true)
    @Override
    public ClassContract getClassContract(Long id) {
        Optional<ClassContract> optional = classContractDAO.findById(id);
        return optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(classContractDAO, request, converter);
    }
}
