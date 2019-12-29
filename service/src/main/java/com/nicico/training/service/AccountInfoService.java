package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.iservice.IAccountInfoService;
import com.nicico.training.model.AccountInfo;
import com.nicico.training.repository.AccountInfoDAO;
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
public class AccountInfoService implements IAccountInfoService {
    private final ModelMapper modelMapper;
    private final AccountInfoDAO accountInfoDAO;

    @Transactional(readOnly = true)
    @Override
    public AccountInfoDTO.Info get(Long id) {
        final Optional<AccountInfo> gById = accountInfoDAO.findById(id);
        final AccountInfo accountInfo = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(accountInfo, AccountInfoDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AccountInfoDTO.Info> list() {
        final List<AccountInfo> gAll = accountInfoDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<AccountInfoDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AccountInfoDTO.Info createOrUpdate(AccountInfoDTO.Create request) {
        if (request.getId() == null)
            return create(request);
        else {
            AccountInfoDTO.Update updating = modelMapper.map(request, AccountInfoDTO.Update.class);
            return update(updating.getId(), updating);
        }
    }

    @Transactional
    @Override
    public AccountInfoDTO.Info create(AccountInfoDTO.Create request) {
        final AccountInfo accountInfo = modelMapper.map(request, AccountInfo.class);
        try {
            return modelMapper.map(accountInfoDAO.saveAndFlush(accountInfo), AccountInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public AccountInfoDTO.Info update(Long id, AccountInfoDTO.Update request) {
        final Optional<AccountInfo> cById = accountInfoDAO.findById(id);
        final AccountInfo accountInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        AccountInfo updating = new AccountInfo();
        modelMapper.map(accountInfo, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(accountInfoDAO.saveAndFlush(updating), AccountInfoDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            accountInfoDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(AccountInfoDTO.Delete request) {
        final List<AccountInfo> gAllById = accountInfoDAO.findAllById(request.getIds());
        accountInfoDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AccountInfoDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(accountInfoDAO, request, accountInfo -> modelMapper.map(accountInfo, AccountInfoDTO.Info.class));
    }

    @Transactional
    @Override
    public void modify(AccountInfoDTO.CreateOrUpdate request, AccountInfo accountInfo) {

    }

}
