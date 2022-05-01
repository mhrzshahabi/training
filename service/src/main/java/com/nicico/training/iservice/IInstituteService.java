package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.Institute;
import org.springframework.data.domain.Pageable;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.function.Function;

public interface IInstituteService {

    InstituteDTO.Info get(Long id);

    Institute getInstitute(Long id);

    List<InstituteDTO.Info> list();

//    InstituteDTO.Info create(Object request, HttpServletResponse response);

//    InstituteDTO.Info update(Long id, LinkedHashMap request, HttpServletResponse response);

    InstituteDTO.Info create(InstituteDTO.Create request, HttpServletResponse response);

    InstituteDTO.Info update(Long id, InstituteDTO.Update request, HttpServletResponse response);

    void delete(Long id);

    void delete(InstituteDTO.Delete request);

    SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<InstituteDTO.ForAgreementInfo> forAgreementInfoSearch(SearchDTO.SearchRq request);

    List<EquipmentDTO.Info> getEquipments(Long instituteId);

    List<TeacherDTO.Info> getTeachers(Long instituteId);

    List<AccountInfoDTO.Info> getInstituteAccounts(Long instituteId);

    List<TrainingPlaceDTO.Info> getTrainingPlaces(Long instituteId);

    void removeEquipment(Long equipmentId, Long instituteId);

    void removeEquipments(List<Long> equipmentIds, Long instituteId);

    void addEquipment(Long equipmentId, Long instituteId);

    void addEquipments(List<Long> equipmentIds, Long instituteId);

    void removeTeacher(Long teacherId, Long instituteId);

    void removeTeachers(List<Long> teacherIds, Long instituteId);

    void addTeacher(Long teacherId, Long instituteId);

    void addTeachers(List<Long> teacherIds, Long instituteId);

    SearchDTO.SearchRs<TeacherDTO.Info> getUnAttachedTeachers(SearchDTO.SearchRq request, Long instituteID);

    List<TeacherDTO.Info> getUnAttachedTeachers(Long instituteID, Pageable pageable);

    Integer getUnAttachedTeachersCount(Long instituteId);

    List<EquipmentDTO.Info> getUnAttachedEquipments(Long instituteId, Pageable pageable);

    Integer getUnAttachedEquipmentsCount(Long instituteId);

    TotalResponse<InstituteDTO.Info> search(NICICOCriteria request);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
