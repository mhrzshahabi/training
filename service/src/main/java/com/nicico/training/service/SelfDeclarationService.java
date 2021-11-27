package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.SelfDeclarationDTO;
import com.nicico.training.iservice.ISelfDeclarationService;
import com.nicico.training.mapper.selfdeclaration.SelfDeclarationMapper;
import com.nicico.training.model.SelfDeclaration;
import com.nicico.training.repository.SelfDeclarationDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SelfDeclarationService implements ISelfDeclarationService {

    private final SelfDeclarationDAO selfDeclarationDAO;
    private final SelfDeclarationMapper selfDeclarationMapper;

    @Override
    @Transactional
    public SelfDeclaration create(SelfDeclarationDTO declarationDTO) {
        SelfDeclaration selfDeclaration = selfDeclarationMapper.requestToEntity(declarationDTO);
        return selfDeclarationDAO.save(selfDeclaration);
    }

    @Override
    public boolean remove(String nationalCode, String mobileNumber) {
        SelfDeclaration selfDeclaration = selfDeclarationDAO.findByNationalCodeAndMobileNumber(nationalCode, mobileNumber).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        selfDeclarationDAO.deleteById(selfDeclaration.getId());
        return true;
    }

    @Override
    public boolean findByNumber(String number) {
        Optional<SelfDeclaration> mobileNumber = selfDeclarationDAO.findByMobileNumber(number);
        return mobileNumber.isPresent();
    }

    @Override
    public List<SelfDeclaration> findByNationalCode(String nationalCode) {
        return selfDeclarationDAO.findAllByNationalCode(nationalCode);
    }

    @Override
    public List<SelfDeclaration> findAll() {
        return selfDeclarationDAO.findAll();
    }
}
