package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.iservice.ICompanyService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
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
        // Company company = mapper.map(request, Company.class);
        // final CompanyDTO.Create create = mapper.map(request, CompanyDTO.Create.class);
        //  final Company company = mapper.map(create, Company.class);
        // Company savedCompany = companyDAO.saveAndFlush(company);
        //  savedCompany.getId();
        //   Set<Long> AccountInfoIdSet = request.getAccountInfoIdSet();
        //        Set<AccountInfo> accountInfoSet = new HashSet<>();
        //        for (Long accountInfoId : AccountInfoIdSet) {
        //            Optional<AccountInfo> optionalAccountInfo = accountInfoDAO.findById(accountInfoId);
        //            AccountInfo accountInfo = optionalAccountInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));
        //            accountInfo.setCompanyId(savedCompany.getId());
        //            accountInfoSet.add(accountInfo);
        //        }
        //   company.setAccountInfoSet(accountInfoSet);

        final AccountInfo accountInfo = mapper.map(request.getAccountInfo(), AccountInfo.class);

        final PersonalInfo personalInfo = mapper.map(request.getManager(), PersonalInfo.class);

        final ContactInfo contactInfo = mapper.map(request.getManager().getContactInfo(), ContactInfo.class);

        final Address address = mapper.map(request.getAddress(), Address.class);

        final Company company = mapper.map(request, Company.class);


        final ContactInfo savedcontactInfo = contactInfoDAO.saveAndFlush(contactInfo);
        personalInfo.setContactInfo(savedcontactInfo);
        personalInfo.setContactInfoId(savedcontactInfo.getId());


        final PersonalInfo savedpersonalInfo = personalInfoDAO.saveAndFlush(personalInfo);
        company.setManager(savedpersonalInfo);
        company.setManagerId(savedpersonalInfo.getId());

        final AccountInfo savedaccountInfo = accountInfoDAO.saveAndFlush(accountInfo);
        company.setAccountInfo(savedaccountInfo);
        company.setAccountInfoId(savedaccountInfo.getId());

        final Address savedAddressInfo = addressDAO.saveAndFlush(address);
        company.setAddress(savedAddressInfo);
        company.setAddressId(savedAddressInfo.getId());


        return mapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);

    }

    @Transactional(readOnly = true)
    @Override
    public CompanyDTO.Info getOneByNationalCode(String nationalCode) {
        List<PersonalInfo> personalInfoList = personalInfoDAO.findByNationalCode(nationalCode);
        PersonalInfo personalInfo = null;
        if (personalInfoList != null && personalInfoList.size() != 0) {
            personalInfo = personalInfoList.get(0);
            List<Company> companyList=companyDAO.findByManagerId(personalInfo.getId());
            Company company=companyList.get(0);
            return mapper.map(company,CompanyDTO.Info.class);
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
