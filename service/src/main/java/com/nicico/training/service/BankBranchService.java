package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.BankBranchDTO;
import com.nicico.training.iservice.IBankBranchService;
import com.nicico.training.model.BankBranch;
import com.nicico.training.repository.BankBranchDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class BankBranchService implements IBankBranchService {
    private final ModelMapper modelMapper;
    private final BankBranchDAO bankBranchDAO;

    @Transactional(readOnly = true)
    @Override
    public BankBranchDTO.Info get(Long id) {
        final Optional<BankBranch> slById = bankBranchDAO.findById(id);
        final BankBranch bankBranch = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.BankBranchNotFound));

        return modelMapper.map(bankBranch, BankBranchDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<BankBranchDTO.Info> list() {
        final List<BankBranch> slAll = bankBranchDAO.findAll();

        return modelMapper.map(slAll, new TypeToken<List<BankBranchDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public BankBranchDTO.Info create(BankBranchDTO.Create request) {
        final BankBranch bankBranch = modelMapper.map(request, BankBranch.class);

        return save(bankBranch);
    }

    @Transactional
    @Override
    public BankBranchDTO.Info update(Long id, BankBranchDTO.Update request) {
        final Optional<BankBranch> slById = bankBranchDAO.findById(id);
        final BankBranch bankBranch = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.BankBranchNotFound));

        BankBranch updating = new BankBranch();
        modelMapper.map(bankBranch, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        bankBranchDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(BankBranchDTO.Delete request) {
        final List<BankBranch> slAllById = bankBranchDAO.findAllById(request.getIds());

        bankBranchDAO.deleteAll(slAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<BankBranchDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(bankBranchDAO, request, bankBranch -> modelMapper.map(bankBranch, BankBranchDTO.Info.class));
    }

    // ------------------------------

    private BankBranchDTO.Info save(BankBranch bankBranch) {
        final BankBranch saved = bankBranchDAO.saveAndFlush(bankBranch);
        return modelMapper.map(saved, BankBranchDTO.Info.class);
    }
}
