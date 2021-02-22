package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
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
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class InstituteService implements IInstituteService {

    private final ModelMapper modelMapper;
    private final InstituteDAO instituteDAO;
    private final EquipmentDAO equipmentDAO;
    private final TeacherDAO teacherDAO;
    private final AccountInfoDAO accountInfoDAO;
    private final AddressDAO addressDAO;
    private final IPersonalInfoService personalInfoService;
    private final ContactInfoService contactInfoService;
    private final TeacherService teacherService;

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
        return modelMapper.map(gAll, new TypeToken<List<InstituteDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public InstituteDTO.Info create(InstituteDTO.Create request, HttpServletResponse response) {
        final Institute institute = modelMapper.map(request, Institute.class);

        if (request.getContactInfo() != null)
            contactInfoService.modify(request.getContactInfo(), institute.getContactInfo());
        if (request.getManagerId() != null)
            institute.setManager(personalInfoService.getPersonalInfo(request.getManagerId()));
        if (request.getParentInstituteId() != null)
            institute.setParentInstitute(getInstitute(request.getParentInstituteId()));
        try {
            return modelMapper.map(instituteDAO.saveAndFlush(institute), InstituteDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public InstituteDTO.Info update(Long id, InstituteDTO.Update request, HttpServletResponse response) {
        final Institute institute = getInstitute(id);
        if (request.getContactInfo() != null && institute.getContactInfo() != null) {
            request.getContactInfo().setId(institute.getContactInfo().getId());
            contactInfoService.modify(request.getContactInfo(), institute.getContactInfo());
        }
        Institute updating = new Institute();
        modelMapper.map(institute, updating);
        modelMapper.map(request, updating);
        if (request.getParentInstituteId() != null)
            updating.setParentInstitute(getInstitute(request.getParentInstituteId()));
        else
            updating.setParentInstitute(null);
        if (request.getManagerId() != null)
            updating.setManager(personalInfoService.getPersonalInfo(request.getManagerId()));
        try {
            return modelMapper.map(instituteDAO.saveAndFlush(updating), InstituteDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        getInstitute(id);
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
        getInstitute(instituteID);
        return modelMapper.map(equipmentDAO.getUnAttachedEquipmentsByInstituteId(instituteID, pageable), new TypeToken<List<EquipmentDTO.Info>>() {
        }.getType());
    }

    @Override
    public Integer getUnAttachedEquipmentsCount(Long instituteID) {
        getInstitute(instituteID);
        return equipmentDAO.getUnAttachedEquipmentsCountByInstituteId(instituteID);
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherDTO.Info> getUnAttachedTeachers(SearchDTO.SearchRq request, Long instituteID) {
        Institute institute = getInstitute(instituteID);
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("id", institute.getTeacherSet().stream().map(Teacher::getId).collect(Collectors.toList()), EOperator.notEqual, null));
        if (request.getCriteria() != null)
            criteria.getCriteria().add(request.getCriteria());
        request.setCriteria(criteria);
        return  teacherService.search(request);
    }

    public List<TeacherDTO.Info> getUnAttachedTeachers(Long instituteID, Pageable pageable) {
        getInstitute(instituteID);
        return modelMapper.map(teacherDAO.getUnAttachedTeachersByInstituteId(instituteID, pageable), new TypeToken<List<TeacherDTO.Info>>() {
        }.getType());
    }

    @Override
    public Integer getUnAttachedTeachersCount(Long instituteID) {
        getInstitute(instituteID);
        return teacherDAO.getUnAttachedTeachersCountByInstituteId(instituteID);
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request) {
        modelMapper.typeMap(Institute.class, InstituteDTO.Info.class).addMapping(
                Institute::getParentInstitute,
                (info, o) -> {
                    if (o != null)
                        info.setParentInstitute(modelMapper.map(o, InstituteDTO.InstituteInfoTuple.class));
                    else
                        info.setParentInstitute(null);
                });
        return SearchUtil.search(instituteDAO, request, institute -> modelMapper.map(institute, InstituteDTO.Info.class));
    }

    @Transactional
    @Override
    public TotalResponse<InstituteDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(instituteDAO, request, term -> modelMapper.map(term, InstituteDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(instituteDAO, request, converter);
    }
}
