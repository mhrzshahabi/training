package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.InstituteDTO;
import com.nicico.training.iservice.IInstituteService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class InstituteService implements IInstituteService {

    private final ModelMapper modelMapper;
    private final InstituteDAO instituteDAO;
    private final EquipmentDAO equipmentDAO;
    private final TeacherDAO teacherDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final AddressDAO addressDAO;
    private final PersonalInfoDAO personalInfoDAO;

    private final TrainingPlaceDAO trainingPlaceDAO;
    private final EnumsConverter.ELicenseTypeConverter eLicenseTypeConverter = new EnumsConverter.ELicenseTypeConverter();
    private final EnumsConverter.EInstituteTypeConverter eInstituteTypeConverter = new EnumsConverter.EInstituteTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public InstituteDTO.Info get(Long id) {
        final Optional<Institute> gById = instituteDAO.findById(id);
        final Institute institute = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        return modelMapper.map(institute, InstituteDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<InstituteDTO.Info> list() {
        final List<Institute> gAll = instituteDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<InstituteDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public InstituteDTO.Info create(Object request) {
        PersonalInfo manager=null;
        Institute parentInstitute=null;
        final InstituteDTO.Create create=modelMapper.map(request,InstituteDTO.Create.class);
        AddressDTO.Create addressCreate=modelMapper.map(create.getAddress(),AddressDTO.Create.class);
        AccountInfoDTO.Create accountCreate=modelMapper.map(create.getAccountInfo(),AccountInfoDTO.Create.class);

        final Address address= modelMapper.map(addressCreate, Address.class);
        final AccountInfo accountInfo= modelMapper.map(accountCreate, AccountInfo.class);

        final Institute institute = modelMapper.map(create, Institute.class);

        if(create.getEinstituteTypeId() != null) {
            institute.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(create.getEinstituteTypeId()));
//            institute.setEInstituteTypeTitleFa(institute.getEInstituteType().getTitleFa());
        }
        if(create.getElicenseTypeId() != null) {
            institute.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(create.getElicenseTypeId()));
//            institute.setELicenseTypeTitleFa(institute.getELicenseType().getTitleFa());
        }
        addressDAO.save(address);
        accountInfoDAO.save(accountInfo);

        institute.setAccountInfoId(accountInfo.getId());
        institute.setAddressId(address.getId());
        institute.setAddress(address);
        institute.setAccountInfo(accountInfo);

        if(institute.getParentInstituteId()!=null){
            Optional<Institute> optionalInstitute=instituteDAO.findById(institute.getParentInstituteId());
            parentInstitute=optionalInstitute.orElseThrow(()->new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        }

        if(institute.getManagerId()!=null){
            Optional<PersonalInfo> optionalPersonalInfo=personalInfoDAO.findById(institute.getManagerId());
            manager=optionalPersonalInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        }

        institute.setManager(manager);
        institute.setParentInstitute(parentInstitute);

        return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, Object request) {
        final InstituteDTO.Update update=modelMapper.map(request,InstituteDTO.Update.class);
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);

        Address address=new Address();
        PersonalInfo manager=null;
        Institute parentInstitute=null;
        AccountInfo accountInfo=new AccountInfo();

        modelMapper.map(updating.getAddress(),address);
        modelMapper.map(updating.getAccountInfo(),accountInfo);


        addressDAO.save(address);
        accountInfoDAO.save(accountInfo);

        updating.setAddress(address);
        updating.setAccountInfo(accountInfo);
        updating.setAddressId(address.getId());
        updating.setAccountInfoId(accountInfo.getId());

         if(updating.getEinstituteTypeId() != null) {
             updating.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(update.getEinstituteTypeId()));
//             updating.setEInstituteTypeTitleFa(updating.getEInstituteType().getTitleFa());
         }
         if(updating.getElicenseTypeId() != null) {
             updating.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(update.getElicenseTypeId()));
//             updating.setELicenseTypeTitleFa(updating.getELicenseType().getTitleFa());
         }
        if(updating.getParentInstituteId()!=null){
            Optional<Institute> optionalInstitute=instituteDAO.findById(updating.getParentInstituteId());
            parentInstitute=optionalInstitute.orElseThrow(()->new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        }

        if(updating.getManagerId()!=null){
            Optional<PersonalInfo> optionalPersonalInfo=personalInfoDAO.findById(updating.getManagerId());
            manager=optionalPersonalInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        }

        updating.setManager(manager);
        updating.setParentInstitute(parentInstitute);

        return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
    }


    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        Long adId=null,acId=null;

        if(institute.getAddressId()!=null)
            adId=institute.getAddressId();
        if(institute.getAccountInfoId()!=null)
            acId=institute.getAccountInfoId();

        instituteDAO.deleteById(id);
        if(adId!=null)
        addressDAO.deleteById(institute.getAddressId());
        if(acId!=null)
        accountInfoDAO.deleteById(institute.getAccountInfoId());
    }

    @Transactional
    @Override
    public void delete(InstituteDTO.Delete request) {
        List<Long> adIds= new ArrayList<>();
        List<Long> acIds= new ArrayList<>();
        final List<Institute> gAllById = instituteDAO.findAllById(request.getIds());
        for (Institute institute : gAllById) {
            if(institute.getAddressId()!=null)
                adIds.add(institute.getAddressId());
            if(institute.getAccountInfoId()!=null)
                acIds.add(institute.getAccountInfoId());
        }
        final List<Address> addresses=addressDAO.findAllById(adIds);
        final List<AccountInfo> accountInfos=accountInfoDAO.findAllById(acIds);
        instituteDAO.deleteAll(gAllById);
        addressDAO.deleteAll(addresses);
        accountInfoDAO.deleteAll(accountInfos);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(instituteDAO, request, institute -> modelMapper.map(institute, InstituteDTO.Info.class));
    }

    // ------------------------------

    private InstituteDTO.Info save(Institute institute, Set<Long> eqiupmentIds,Set<Long> teacherIds,Set<Long> trainingPleceIds) {

        final Set<Equipment> equipmentSet=new HashSet<>();
        final Set<Teacher> teacherSet=new HashSet<>();
        final Set<TrainingPlace> trainingPlaceSet=new HashSet<>();

        AccountInfo accountInfo=null;
        Address address=null;
        PersonalInfo manager=null;
        Institute parentInstitute=null;

        Optional.ofNullable(eqiupmentIds).ifPresent(equpmentIdSet->equpmentIdSet.forEach(equipmentId->equipmentSet.add(equipmentDAO.findById(equipmentId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.EquipmentNotFound)))));
        Optional.ofNullable(teacherIds).ifPresent(teacherIdSet->teacherIdSet.forEach(teacherId->teacherSet.add(teacherDAO.findById(teacherId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.TeacherNotFound)))));
        Optional.ofNullable(trainingPleceIds).ifPresent(trainingPleceIdSet->trainingPleceIdSet.forEach(trainingPleceId->trainingPlaceSet.add(trainingPlaceDAO.findById(trainingPleceId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.TrainingPlaceNotFound)))));


        if(institute.getAccountInfoId()!=null){
            Optional<AccountInfo> optionalAccountInfo=accountInfoDAO.findById(institute.getAccountInfoId());
            accountInfo=optionalAccountInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));
        }
        if(institute.getAddressId()!=null){
            Optional<Address> optionalAddress=addressDAO.findById(institute.getAddressId());
            address=optionalAddress.orElseThrow(()->new TrainingException(TrainingException.ErrorType.AddressNotFound));

        }
        if(institute.getManagerId()!=null){
           Optional<PersonalInfo> optionalPersonalInfo=personalInfoDAO.findById(institute.getManagerId());
            manager=optionalPersonalInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        }
        if(institute.getParentInstituteId()!=null){
            Optional<Institute> optionalInstitute=instituteDAO.findById(institute.getParentInstituteId());
            parentInstitute=optionalInstitute.orElseThrow(()->new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        }

        institute.setEquipmentSet(equipmentSet);
        institute.setTeacherSet(teacherSet);
        institute.setTrainingPlaceSet(trainingPlaceSet);

        institute.setAccountInfo(accountInfo);
        institute.setAddress(address);
        institute.setManager(manager);
        institute.setParentInstitute(parentInstitute);


        final Institute saved = instituteDAO.saveAndFlush(institute);
        return modelMapper.map(saved, InstituteDTO.Info.class);
    }

   }
