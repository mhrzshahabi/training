package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
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

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class InstituteService implements IInstituteService {

    private final ModelMapper modelMapper;
    private final InstituteDAO instituteDAO;
    private final EquipmentDAO equipmentDAO;
    private final TeacherDAO teacherDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final ContactInfoDAO contactInfoDAO;
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
    public InstituteDTO.Info create(InstituteDTO.Create request) {
        final Institute institute = modelMapper.map(request, Institute.class);
        if(request.getEInstituteTypeId() != null) {
            institute.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(request.getEInstituteTypeId()));
//            institute.setEInstituteTypeTitleFa(institute.getEInstituteType().getTitleFa());
        }
        if(request.getELicenseTypeId() != null) {
            institute.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(request.getELicenseTypeId()));
//            institute.setELicenseTypeTitleFa(institute.getELicenseType().getTitleFa());
        }
        return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, InstituteDTO.Update request) {
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);
         if(request.getEInstituteTypeId() != null) {
             updating.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(request.getEInstituteTypeId()));
//             updating.setEInstituteTypeTitleFa(updating.getEInstituteType().getTitleFa());
         }
         if(request.getELicenseTypeId() != null) {
             updating.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(request.getELicenseTypeId()));
//             updating.setELicenseTypeTitleFa(updating.getELicenseType().getTitleFa());
         }

        return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
    }


    @Transactional
    @Override
    public void delete(Long id) {
        instituteDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(InstituteDTO.Delete request) {
        final List<Institute> gAllById = instituteDAO.findAllById(request.getIds());
        instituteDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(instituteDAO, request, institute -> modelMapper.map(institute, InstituteDTO.Info.class));
    }

    // ------------------------------

    private InstituteDTO.Info save(Institute institute, Set<Long> equpmentIds,Set<Long> teacherIds,Set<Long> trainingPleceIds) {

        final Set<Equipment> equipmentSet=new HashSet<>();
        final Set<Teacher> teacherSet=new HashSet<>();
        final Set<TrainingPlace> trainingPlaceSet=new HashSet<>();

        AccountInfo accountInfo=null;
        ContactInfo contactInfo=null;
        PersonalInfo manager=null;
        Institute parentInstitute=null;

        Optional.ofNullable(equpmentIds).ifPresent(equpmentIdSet->equpmentIdSet.forEach(equipmentId->equipmentSet.add(equipmentDAO.findById(equipmentId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.EquipmentNotFound)))));
        Optional.ofNullable(teacherIds).ifPresent(teacherIdSet->teacherIdSet.forEach(teacherId->teacherSet.add(teacherDAO.findById(teacherId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.TeacherNotFound)))));
        Optional.ofNullable(trainingPleceIds).ifPresent(trainingPleceIdSet->trainingPleceIdSet.forEach(trainingPleceId->trainingPlaceSet.add(trainingPlaceDAO.findById(trainingPleceId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.TrainingPlaceNotFound)))));


        if(institute.getAccountInfoId()!=null){
            Optional<AccountInfo> optionalAccountInfo=accountInfoDAO.findById(institute.getAccountInfoId());
            accountInfo=optionalAccountInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.AccountInfoNotFound));
        }
        if(institute.getContactInfoId()!=null){
            Optional<ContactInfo> optionalContactInfo=contactInfoDAO.findById(institute.getContactInfoId());
            contactInfo=optionalContactInfo.orElseThrow(()->new TrainingException(TrainingException.ErrorType.ContactInfoNotFound));

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
        institute.setContactInfo(contactInfo);
        institute.setManager(manager);
        institute.setParentInstitute(parentInstitute);


        final Institute saved = instituteDAO.saveAndFlush(institute);
        return modelMapper.map(saved, InstituteDTO.Info.class);
    }

   }
