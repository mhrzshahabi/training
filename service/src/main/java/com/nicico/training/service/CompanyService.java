package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.ICompanyService;
import com.nicico.training.model.AccountInfo;
import com.nicico.training.model.Address;
import com.nicico.training.model.Company;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.repository.AccountInfoDAO;
import com.nicico.training.repository.AddressDAO;
import com.nicico.training.repository.CompanyDAO;
import com.nicico.training.repository.PersonalInfoDAO;
import lombok.RequiredArgsConstructor;
import org.apache.catalina.Manager;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CompanyService implements ICompanyService {
    private final CompanyDAO companyDAO;
    private final ModelMapper modelMapper;
    private final AddressService addressService;
    private final PersonalInfoService personalInfoService;
    private final AccountInfoService accountInfoService;
    private final AccountInfoDAO accountInfoDAO;
    private final AddressDAO addressDAO;
    private final PersonalInfoDAO personalInfoDAO;


    @Transactional(readOnly = true)
    @Override
    public CompanyDTO.Info get(Long id) {
        return modelMapper.map(getCompany(id), CompanyDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Company getCompany(Long id) {
        final Optional<Company> optionalCompany = companyDAO.findById(id);
        return optionalCompany.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
    }

    @Transactional
    @Override
    public List<CompanyDTO.Info> list() {
        List<Company> companyList = companyDAO.findAll();
        return modelMapper.map(companyList, new TypeToken<List<CompanyDTO.Info>>() {
        }.getType());
    }


    @Transactional
    @Override
    public CompanyDTO.Info update(Long id, CompanyDTO.Update request) {
        Company currentCompany = companyDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Company company = new Company();
        modelMapper.map(currentCompany, company);
        modelMapper.map(request, company);
        try {
            updateManager(request, currentCompany.getManagerId(), company);
        } catch (Exception ex) {
            throw new TrainingException(TrainingException.ErrorType.RecordAlreadyExists);
        }
        updateAccountInfo(request, currentCompany.getAccountInfoId(), company);
        try {
            updateAddress(request, currentCompany.getAddressId(), company);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        try {
            return modelMapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    public void updateManager(CompanyDTO.Update request, Long id, Company company) throws Exception {
        PersonalInfo personalInfo = personalInfoDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        modelMapper.map(request.getManager(), personalInfo);
        personalInfoDAO.saveAndFlush(personalInfo);
  }

    @Transactional
    public void updateAddress(CompanyDTO.Update request, Long id, Company company) throws Exception {
        Address address = addressDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if (address.getPostalCode().equals(request.getAddress().getPostalCode())) {
            modelMapper.map(request.getAddress(), address);
            addressDAO.saveAndFlush(address);

        }
       }

    @Transactional
    public void updateAccountInfo(CompanyDTO.Update request, Long id, Company company) {
        AccountInfo accountInfo = accountInfoDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        modelMapper.map(request.getAccountInfo(), accountInfo);
        accountInfoDAO.saveAndFlush(accountInfo);
        // company.setAccountInfo(accountInfo);
        // company.setAccountInfoId(accountInfo.getId());
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            companyDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
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
        return SearchUtil.search(companyDAO, request, company -> modelMapper.map(company, CompanyDTO.Info.class));
    }

    @Transactional
    @Override
    public CompanyDTO.Info create(CompanyDTO.Create request) {
        final Company company = modelMapper.map(request, Company.class);
        try {
            setAddress(request, company);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        setManager(request, company);
        if (null!=request.getAccountInfo())
        setAccountInfo(request, company);
        return modelMapper.map(companyDAO.saveAndFlush(company), CompanyDTO.Info.class);
    }

    public void setAddress(CompanyDTO.Create request, Company company) throws Exception {
        Address address1 = null;
        if(request.getAddress()!=null && request.getAddress().getPostalCode() != null) {
            Optional<Address> addressOptional = addressDAO.findByPostalCode(request.getAddress().getPostalCode());
            address1 = addressOptional.orElse(null);
        }
        if (address1 != null) {
            List<Company> companyList = companyDAO.findByAddressId(address1.getId());
            if (companyList.size() > 0) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            } else {
                Address address = addressDAO.findByPostalCode(request.getAddress().getPostalCode()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                 if (address != null) {
                    company.setAddressId(address.getId());
                    company.setAddress(address);
                } else {
                    AddressDTO.Info AddressDTOInfo = addressService.create(modelMapper.map(request.getAddress(), AddressDTO.Create.class));
                    Address address2 = addressDAO.findById(AddressDTOInfo.getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    company.setAddressId(address2.getId());
                    company.setAddress(address2);
                }
            }


        }else
        {
            if (request.getAddress()!=null)
            {
                AddressDTO.Info AddressDTOInfo = addressService.create(modelMapper.map(request.getAddress(), AddressDTO.Create.class));
                Address address2 = addressDAO.findById(AddressDTOInfo.getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                company.setAddressId(address2.getId());
                company.setAddress(address2);
            }

        }
    }

    public void setManager(CompanyDTO.Create request, Company company) {
        if (request.getManager() != null && request.getManager().getId() != null) {
            PersonalInfo manager = personalInfoService.getPersonalInfo(request.getManager().getId());
            request.setManagerId(manager.getId());
            modelMapper.map(request.getManager(), manager);
            company.setManagerId(manager.getId());
            company.setManager(manager);
            request.setManager(modelMapper.map(manager, PersonalInfoDTO.CompanyManager.class));
        } else if (request.getManager() != null && request.getManager().getId() == null) {
            PersonalInfoDTO.Info PersonalInfoDTOInfo = personalInfoService.create(modelMapper.map(request.getManager(), PersonalInfoDTO.Create.class));
            PersonalInfo personalInfo = personalInfoDAO.findById(PersonalInfoDTOInfo.getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            company.setManagerId(personalInfo.getId());
            company.setManager(personalInfo);
        }
    }

    public void setAccountInfo(CompanyDTO.Create request, Company company) {
        AccountInfoDTO.Info accountInfoDTO = accountInfoService.create(modelMapper.map(request.getAccountInfo(), AccountInfoDTO.Create.class));
        AccountInfo accountInfo = accountInfoDAO.findById(accountInfoDTO.getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        company.setAccountInfo(accountInfo/*modelMapper.map(accountInfoDTO, AccountInfo.class)*/);
    }


}
