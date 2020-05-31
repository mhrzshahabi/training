package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
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
    private final IPersonalInfoService personalInfoService;
    private final IEducationLevelService educationLevelService;
    private final IEducationMajorService educationMajorService;
    private final IEducationOrientationService educationOrientationService;

    @Transactional(readOnly = true)
    @Override
    public InstituteDTO.Info get(Long id) {
        return modelMapper.map(getInstitute(id), InstituteDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Institute getInstitute(Long id) {
        final Optional<Institute> gById = instituteDAO.findById(id);
        return gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.InstituteNotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public List<InstituteDTO.Info> list() {
        final List<Institute> gAll = instituteDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<InstituteDTO.Info>>(){}.getType());
    }

    @Transactional
    @Override
    public InstituteDTO.Info create(InstituteDTO.Create request, HttpServletResponse response) {
        final Institute institute = modelMapper.map(request, Institute.class);

        if (institute.getContactInfo().getWorkAddress().getPostalCode()!=null && addressDAO.existsByPostalCode(institute.getContactInfo().getWorkAddress().getPostalCode())) {
            try {
                response.sendError(405, null);
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

        PersonalInfo personalInfo = personalInfoService.getPersonalInfo(request.getManagerId());
        personalInfoService.modify(request.getManager(), personalInfo);
        institute.setManager(personalInfo);
        try {
            return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, InstituteDTO.Update request, HttpServletResponse response) {
        String postalCode=request.getContactInfo().getWorkAddress().getPostalCode();
        Long idAddress=request.getContactInfo().getWorkAddress().getId();

        boolean status=false;

        if (postalCode!=null && idAddress !=null)
            status=addressDAO.existsByPostalCodeAndIdNot(postalCode,idAddress);

        if (postalCode!=null && status)
        {
            try {
                response.sendError(405,null);
                return null;
            } catch (IOException e){
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

        PersonalInfo personalInfo = modelMapper.map(personalInfoService.getOneByNationalCode(request.getManager().getNationalCode()), PersonalInfo.class);
        final Institute institute = getInstitute(id);
        if (personalInfo != null) {
            EducationLevel educationLevel = null;
            EducationMajor educationMajor = null;
            EducationOrientation educationOrientation = null;
            if (request.getManager().getEducationLevelId() != null)
                educationLevel = modelMapper.map(educationLevelService.get(request.getManager().getEducationLevelId()), EducationLevel.class);
            if (request.getManager().getEducationMajorId() != null)
                educationMajor = modelMapper.map(educationMajorService.get(request.getManager().getEducationMajorId()), EducationMajor.class);
            if (request.getManager().getEducationOrientationId() != null)
                educationOrientation = modelMapper.map(educationOrientationService.get(request.getManager().getEducationOrientationId()), EducationOrientation.class);
            personalInfo.setEducationLevel(educationLevel);
            personalInfo.setEducationMajor(educationMajor);
            personalInfo.setEducationOrientation(educationOrientation);
            personalInfoService.modify(request.getManager(), personalInfo);
            request.getManager().setId(personalInfo.getId());
            request.setManagerId(personalInfo.getId());
            institute.setManager(personalInfo);
        }
        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
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
