package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.EquipmentDTO;
import com.nicico.training.iservice.IInstituteAccountService;
import com.nicico.training.model.AccountInfo;
import com.nicico.training.model.Institute;
import com.nicico.training.model.InstituteAccount;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class InstituteAccountService implements IInstituteAccountService {
    private final ModelMapper modelMapper;
    private final AccountInfoDAO accountInfoDAO;
    private final InstituteDAO instituteDAO;

    @Transactional
    @Override
    public AccountInfoDTO.CreateOrUpdate create(Object request) {
        final AccountInfoDTO.CreateOrUpdate account = modelMapper.map(request, AccountInfoDTO.CreateOrUpdate.class);
        return save(account);
    }

    public AccountInfoDTO.CreateOrUpdate save(AccountInfoDTO.CreateOrUpdate account){
        AccountInfo accountInfo=modelMapper.map(account, AccountInfo.class);
        accountInfo.setInstituteId(account.getInstituteId());
        accountInfo.setInstitute(instituteDAO.getOne(account.getInstituteId()));

        final AccountInfo saved = accountInfoDAO.saveAndFlush(accountInfo);
        return modelMapper.map(saved, AccountInfoDTO.CreateOrUpdate.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AccountInfoDTO.Info> list() {
        final List<AccountInfo> slAll = accountInfoDAO.findAll();
        return modelMapper.map(slAll, new TypeToken<List<AccountInfoDTO.Info>>(){}.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AccountInfoDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(accountInfoDAO, request, account -> modelMapper.map(account, AccountInfoDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<AccountInfoDTO.Info> get(Long id, Pageable pageable) {
        final List<AccountInfo> accountInfos = accountInfoDAO.findAllByInstituteId(id,pageable);
        return modelMapper.map(accountInfos, new TypeToken<List<AccountInfoDTO.Info>>() {}.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<AccountInfoDTO.Info> getAllAccountForExcel(Long instituteId) {
        final List<AccountInfo> accountInfos = accountInfoDAO.getAllByInstituteId(instituteId);
        return modelMapper.map(accountInfos, new TypeToken<List<AccountInfoDTO.Info>>() {}.getType());
    }

    @Transactional
    @Override
    public AccountInfoDTO.CreateOrUpdate update(Long id, Object request) {

        final Optional<AccountInfo> slById = accountInfoDAO.findById(id);
        final AccountInfo account = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));
        InstituteAccount updating = new InstituteAccount();

        modelMapper.map(account, updating);
        modelMapper.map(request, updating);

        return save(modelMapper.map(request, AccountInfoDTO.CreateOrUpdate.class));
    }

    @Transactional
    @Override
    public void delete(Long id) {
        accountInfoDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(AccountInfoDTO.Delete request) {
        final List<AccountInfo> slAllById = accountInfoDAO.findAllById(request.getIds());
        accountInfoDAO.deleteAll(slAllById);
    }
}
