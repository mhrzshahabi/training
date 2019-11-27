package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.ICompanyService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
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
public class CompanyService implements ICompanyService {
    private final CompanyDAO companyDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final PersonalInfoDAO personalInfoDAO;
    private final ContactInfoDAO contactInfoDAO;
    private final AddressDAO addressDAO;
    private final ModelMapper mapper;
    private final AccountInfoService accountInfoService;
    private final AddressService addressService;


    @Transactional(readOnly = true)
    @Override
    public CompanyDTO.Info get(Long id) {
        final Optional<Company> optionalCompany = companyDAO.findById(id);
        final Company company = optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return mapper.map(company, CompanyDTO.Info.class);
    }

    @Transactional
    @Override
    public List<CompanyDTO.Info> list() {
        List<Company> companyList = companyDAO.findAll();
        return mapper.map(companyList, new TypeToken<List<CompanyDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CompanyDTO.Info create(CompanyDTO.Create request) {

        final Company company = mapper.map(request, Company.class);

        if (company.getAccountInfo() != null) {
            final AccountInfoDTO.Create accountInfo = mapper.map(company.getAccountInfo(), AccountInfoDTO.Create.class);
            final AccountInfoDTO.Info savedAccountInfo = accountInfoService.create(accountInfo);
            company.setAccountInfo(mapper.map(savedAccountInfo, AccountInfo.class));
            company.setAccountInfoId(savedAccountInfo.getId());
        }

        if (company.getAddress() != null) {
            final Address address = mapper.map(company.getAddress(), Address.class);
            final Address savedAddressInfo = addressDAO.saveAndFlush(address);
            company.setAddress(savedAddressInfo);
            company.setAddressId(savedAddressInfo.getId());

//            final AddressDTO.Create address = mapper.map(company.getAddress(), AddressDTO.Create.class);
//            final AddressDTO.Info savedAddress = addressService.createOrUpdate(address);
//            company.setAddress(mapper.map(savedAddress, Address.class));
//            company.setAddressId(savedAddress.getId());
        }

        try {
            return mapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

    }

    @Transactional(readOnly = true)
    @Override
    public PersonalInfoDTO.Info getOneByNationalCode(String nationalCode) {
        List<PersonalInfo> personalInfoList = personalInfoDAO.findByNationalCode(nationalCode);
        PersonalInfo personalInfo = null;
        if (personalInfoList != null && personalInfoList.size() != 0) {
            personalInfo = personalInfoList.get(0);
            return mapper.map(personalInfo, PersonalInfoDTO.Info.class);
        } else
            return null;
    }


    @Transactional
    @Override
    public CompanyDTO.Info update(Long id, CompanyDTO.Update request) {
        Optional<Company> optionalCompany = companyDAO.findById(id);
        Company currentCompany = optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompanyNotFound));

        PersonalInfo currentPersonalInfo = mapper.map(request.getManager(), PersonalInfo.class);
        currentPersonalInfo.getContactInfoId();//contactInfoId


        //---------------------UPDATE AccountInfo---------------------------------------------------------------------------------------------------
        Optional<AccountInfo> optionalAccountInfo = accountInfoDAO.findById(currentCompany.getAccountInfoId());
        AccountInfo accountInfo = optionalAccountInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));
        AccountInfo accountInfo1 = new AccountInfo();
        mapper.map(accountInfo, accountInfo1);
        mapper.map(request.getAccountInfo(), accountInfo1);
        accountInfoDAO.saveAndFlush(accountInfo1);

        //------------------ --UPDATE MANAGER----- -------------------------------------------------------------------------------------------------
        Optional<PersonalInfo> optionalManager = personalInfoDAO.findById(currentCompany.getManagerId());
        PersonalInfo manager = optionalManager.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        PersonalInfo manager1 = new PersonalInfo();
        mapper.map(manager, manager1);
        mapper.map(request.getManager(), manager1);
        personalInfoDAO.saveAndFlush(manager1);

        Company company = new Company();
        mapper.map(currentCompany, company);

        mapper.map(request, company);
        return mapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        companyDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CompanyDTO.Delete request) {
        final List<Company> companyList = companyDAO.findAllById(request.getIds());
        companyDAO.deleteAll(companyList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CompanyDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(companyDAO, request, company -> mapper.map(company, CompanyDTO.Info.class));
    }


}
