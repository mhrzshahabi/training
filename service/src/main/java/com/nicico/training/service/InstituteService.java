package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IInstituteService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Pageable;
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

    private final AddressService addressService;

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
        PersonalInfo manager = null;
        Institute parentInstitute = null;
        final InstituteDTO.Create create = modelMapper.map(request, InstituteDTO.Create.class);


        final Institute institute = modelMapper.map(create, Institute.class);

        if (create.getEinstituteTypeId() != null) {
            institute.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(create.getEinstituteTypeId()));
          // institute.setEInstituteTypeTitleFa(institute.getEInstituteType().getTitleFa());
        }
        if (create.getElicenseTypeId() != null) {
            institute.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(create.getElicenseTypeId()));
//            institute.setELicenseTypeTitleFa(institute.getELicenseType().getTitleFa());
        }

        if (institute.getParentInstituteId() != null) {
            Optional<Institute> optionalInstitute = instituteDAO.findById(institute.getParentInstituteId());
            parentInstitute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        }

        if (institute.getManagerId() != null) {
            Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(institute.getManagerId());
            manager = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        }

        institute.setManager(manager);
        institute.setParentInstitute(parentInstitute);

        return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, Object request) {


        final InstituteDTO.Update update = modelMapper.map(request, InstituteDTO.Update.class);
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);

        Address address = new Address();
        Institute parentInstitute = null;
        AccountInfo accountInfo = new AccountInfo();

        addressDAO.saveAndFlush(address);
        accountInfoDAO.save(accountInfo);


        if (updating.getEinstituteTypeId() != null) {
            updating.setEInstituteType(eInstituteTypeConverter.convertToEntityAttribute(update.getEinstituteTypeId()));
//             updating.setEInstituteTypeTitleFa(updating.getEInstituteType().getTitleFa());
        }
        if (updating.getElicenseTypeId() != null) {
            updating.setELicenseType(eLicenseTypeConverter.convertToEntityAttribute(update.getElicenseTypeId()));
//             updating.setELicenseTypeTitleFa(updating.getELicenseType().getTitleFa());
        }
        if (updating.getParentInstituteId() != null) {
            Optional<Institute> optionalInstitute = instituteDAO.findById(updating.getParentInstituteId());
            parentInstitute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        }

        /*if (updating.getManagerId() != null) {
            Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(updating.getManagerId());
            PersonalInfo manager = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
            updating.setManagerId(updating.getManagerId());
        }
*/
        updating.setParentInstitute(parentInstitute);

        return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
    }


    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Institute> cById = instituteDAO.findById(id);
        final Institute institute = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        Long adId = null, acId = null;


        instituteDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(InstituteDTO.Delete request) {
        List<Long> adIds = new ArrayList<>();
        List<Long> acIds = new ArrayList<>();
        final List<Institute> gAllById = instituteDAO.findAllById(request.getIds());
        final List<Address> addresses = addressDAO.findAllById(adIds);
        final List<AccountInfo> accountInfos = accountInfoDAO.findAllById(acIds);
        instituteDAO.deleteAll(gAllById);
        addressDAO.deleteAll(addresses);
        accountInfoDAO.deleteAll(accountInfos);
    }


    @Transactional(readOnly = true)
    @Override
    public List<EquipmentDTO.Info> getEquipments(Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return modelMapper.map(institute.getEquipmentSet(), new TypeToken<List<EquipmentDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<TeacherDTO.Info> getTeachers(Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return modelMapper.map(institute.getTeacherSet(), new TypeToken<List<TeacherDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<AccountInfoDTO.Info> getInstituteAccounts(Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        return modelMapper.map(institute.getAccountInfoSet(), new TypeToken<List<AccountInfoDTO.Info>>() {
        }.getType());

    }

    @Transactional(readOnly = true)
    @Override
    public List<TrainingPlaceDTO.Info> getTrainingPlaces(Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        return modelMapper.map(institute.getTrainingPlaceSet(), new TypeToken<List<TrainingPlaceDTO.Info>>() {
        }.getType());

    }


    @Transactional
    @Override
    public void removeEquipment(Long equipmentId, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        final Optional<Equipment> optionalEquipment = equipmentDAO.findById(equipmentId);
        final Equipment equipment = optionalEquipment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));
        institute.getEquipmentSet().remove(equipment);
    }

    @Transactional
    @Override
    public void removeEquipments(List<Long> equipmentIds, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        List<Equipment> gAllById = equipmentDAO.findAllById(equipmentIds);
        for (Equipment equipment : gAllById) {
            institute.getEquipmentSet().remove(equipment);
        }
    }

    @Transactional
    @Override
    public void addEquipment(Long equipmentId, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        final Optional<Equipment> optionalEquipment = equipmentDAO.findById(equipmentId);
        final Equipment equipment = optionalEquipment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));
        institute.getEquipmentSet().add(equipment);
    }

    @Transactional
    @Override
    public void addEquipments(List<Long> equipmentIds, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        List<Equipment> gAllById = equipmentDAO.findAllById(equipmentIds);
        for (Equipment equipment : gAllById) {
            institute.getEquipmentSet().add(equipment);
        }
    }


    @Transactional
    @Override
    public void removeTeacher(Long teacherId, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        final Optional<Teacher> optionalTeacher = teacherDAO.findById(teacherId);
        final Teacher teacher = optionalTeacher.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        institute.getTeacherSet().remove(teacher);
    }

    @Transactional
    @Override
    public void removeTeachers(List<Long> teacherIds, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        List<Teacher> gAllById = teacherDAO.findAllById(teacherIds);
        for (Teacher teacher : gAllById) {
            institute.getTeacherSet().remove(teacher);
        }
    }

    @Transactional
    @Override
    public void addTeacher(Long teacherId, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        final Optional<Teacher> optionalTeacher = teacherDAO.findById(teacherId);
        final Teacher teacher = optionalTeacher.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        institute.getTeacherSet().add(teacher);
    }

    @Transactional
    @Override
    public void addTeachers(List<Long> teacherIds, Long instituteId) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteId);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
        List<Teacher> gAllById = teacherDAO.findAllById(teacherIds);
        for (Teacher teacher : gAllById) {
            institute.getTeacherSet().add(teacher);
        }
    }


    @Transactional(readOnly = true)
    @Override
    public List<EquipmentDTO.Info> getUnAttachedEquipments(Long instituteID, Pageable pageable) {

        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteID);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return modelMapper.map(equipmentDAO.getUnAttachedEquipmentsByInstituteId(instituteID, pageable), new TypeToken<List<EquipmentDTO.Info>>() {
        }.getType());
    }

    @Override
    public Integer getUnAttachedEquipmentsCount(Long instituteID) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteID);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return equipmentDAO.getUnAttachedEquipmentsCountByInstituteId(instituteID);
    }


    @Transactional(readOnly = true)
    @Override
    public List<TeacherDTO.Info> getUnAttachedTeachers(Long instituteID, Pageable pageable) {

        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteID);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return modelMapper.map(teacherDAO.getUnAttachedTeachersByInstituteId(instituteID, pageable), new TypeToken<List<TeacherDTO.Info>>() {
        }.getType());
    }

    @Override
    public Integer getUnAttachedTeachersCount(Long instituteID) {
        final Optional<Institute> optionalInstitute = instituteDAO.findById(instituteID);
        final Institute institute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));


        return teacherDAO.getUnAttachedTeachersCountByInstituteId(instituteID);
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(instituteDAO, request, institute -> modelMapper.map(institute, InstituteDTO.Info.class));
    }

    // ------------------------------

    private InstituteDTO.Info save(Institute institute, Set<Long> eqiupmentIds, Set<Long> teacherIds, Set<Long> trainingPleceIds) {

        final Set<Equipment> equipmentSet = new HashSet<>();
        final Set<Teacher> teacherSet = new HashSet<>();
        final Set<TrainingPlace> trainingPlaceSet = new HashSet<>();

        AccountInfo accountInfo = null;
        Address address = null;
        PersonalInfo manager = null;
        Institute parentInstitute = null;

        Optional.ofNullable(eqiupmentIds).ifPresent(equpmentIdSet -> equpmentIdSet.forEach(equipmentId -> equipmentSet.add(equipmentDAO.findById(equipmentId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound)))));
        Optional.ofNullable(teacherIds).ifPresent(teacherIdSet -> teacherIdSet.forEach(teacherId -> teacherSet.add(teacherDAO.findById(teacherId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound)))));
        Optional.ofNullable(trainingPleceIds).ifPresent(trainingPleceIdSet -> trainingPleceIdSet.forEach(trainingPleceId -> trainingPlaceSet.add(trainingPlaceDAO.findById(trainingPleceId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPlaceNotFound)))));


        if (institute.getManagerId() != null) {
            Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(institute.getManagerId());
            manager = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        }
        if (institute.getParentInstituteId() != null) {
            Optional<Institute> optionalInstitute = instituteDAO.findById(institute.getParentInstituteId());
            parentInstitute = optionalInstitute.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        }

        institute.setEquipmentSet(equipmentSet);
        institute.setTeacherSet(teacherSet);
        institute.setTrainingPlaceSet(trainingPlaceSet);

        institute.setManager(manager);
        institute.setParentInstitute(parentInstitute);


        final Institute saved = instituteDAO.saveAndFlush(institute);
        return modelMapper.map(saved, InstituteDTO.Info.class);
    }

    @Transactional
    @Override
    public TotalResponse<InstituteDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(instituteDAO, request, term -> modelMapper.map(term, InstituteDTO.Info.class));
    }
}
