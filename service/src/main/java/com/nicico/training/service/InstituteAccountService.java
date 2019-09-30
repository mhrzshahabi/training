package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.InstituteAccountDTO;
import com.nicico.training.iservice.IInstituteAccountService;
import com.nicico.training.model.InstituteAccount;
import com.nicico.training.repository.InstituteAccountDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class InstituteAccountService implements IInstituteAccountService {
    private final ModelMapper modelMapper;
    private final InstituteAccountDAO instituteAccountDAO;

    @Transactional(readOnly = true)
    @Override
    public InstituteAccountDTO.Info get(Long id) {
        final Optional<InstituteAccount> slById = instituteAccountDAO.findById(id);
        final InstituteAccount account = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));

        return modelMapper.map(account, InstituteAccountDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<InstituteAccountDTO.Info> list() {
        final List<InstituteAccount> slAll = instituteAccountDAO.findAll();

        return modelMapper.map(slAll, new TypeToken<List<InstituteAccountDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public InstituteAccountDTO.Info create(Object request) {
        final InstituteAccount account = modelMapper.map(request, InstituteAccount.class);

        return save(account);
    }

    @Transactional
    @Override
    public InstituteAccountDTO.Info update(Long id, Object request) {
        final Optional<InstituteAccount> slById = instituteAccountDAO.findById(id);
        final InstituteAccount account = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));

        InstituteAccount updating = new InstituteAccount();
        modelMapper.map(account, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        instituteAccountDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(InstituteAccountDTO.Delete request) {
        final List<InstituteAccount> slAllById = instituteAccountDAO.findAllById(request.getIds());

        instituteAccountDAO.deleteAll(slAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteAccountDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(instituteAccountDAO, request, account -> modelMapper.map(account, InstituteAccountDTO.Info.class));
    }

    // ------------------------------

    private InstituteAccountDTO.Info save(InstituteAccount account) {
        final InstituteAccount saved = instituteAccountDAO.saveAndFlush(account);
        return modelMapper.map(saved, InstituteAccountDTO.Info.class);
    }
}
