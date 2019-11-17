package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.BankBranchDTO;
import com.nicico.training.dto.BankDTO;
import com.nicico.training.iservice.IBankService;
import com.nicico.training.model.Bank;
import com.nicico.training.repository.BankDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class BankService implements IBankService {
    private final ModelMapper modelMapper;
    private final BankDAO bankDAO;

    @Transactional(readOnly = true)
    @Override
    public BankDTO.Info get(Long id) {
        final Optional<Bank> slById = bankDAO.findById(id);
        final Bank bank = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.BankNotFound));

        return modelMapper.map(bank, BankDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<BankDTO.Info> list() {
        final List<Bank> slAll = bankDAO.findAll();

        return modelMapper.map(slAll, new TypeToken<List<BankDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public BankDTO.Info create(BankDTO.Create request) {
        final Bank bank = modelMapper.map(request, Bank.class);

        return save(bank);
    }

    @Transactional
    @Override
    public BankDTO.Info update(Long id, BankDTO.Update request) {
        final Optional<Bank> slById = bankDAO.findById(id);
        final Bank bank = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.BankNotFound));

        Bank updating = new Bank();
        modelMapper.map(bank, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        bankDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(BankDTO.Delete request) {
        final List<Bank> slAllById = bankDAO.findAllById(request.getIds());

        bankDAO.deleteAll(slAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<BankDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(bankDAO, request, bank -> modelMapper.map(bank, BankDTO.Info.class));
    }

    // ------------------------------

    private BankDTO.Info save(Bank bank) {
        final Bank saved = bankDAO.saveAndFlush(bank);
        return modelMapper.map(saved, BankDTO.Info.class);
    }


    @Transactional(readOnly = true)
    @Override
    public List<BankBranchDTO.Info> getBankBranches(Long bankID) {
        final Optional<Bank> optionalBank = bankDAO.findById(bankID);
        final Bank bank = optionalBank.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.BankNotFound));

        return modelMapper.map(bank.getBankBranchSet(), new TypeToken<List<BankBranchDTO.Info>>() {}.getType());
    }


}
