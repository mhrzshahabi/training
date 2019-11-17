package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IInstituteService {

    InstituteDTO.Info get(Long id);

    List<InstituteDTO.Info> list();

    InstituteDTO.Info create(Object request);

    InstituteDTO.Info update(Long id, Object request);

    void delete(Long id);

    void delete(InstituteDTO.Delete request);

    SearchDTO.SearchRs<InstituteDTO.Info> search(SearchDTO.SearchRq request);

    List<EquipmentDTO.Info> getEquipments(Long instituteId);

    List<TeacherDTO.Info> getTeachers(Long instituteId);

    List<InstituteAccountDTO.Info> getInstituteAccounts(Long instituteId);
    List<TrainingPlaceDTO.Info> getTrainingPlaces(Long instituteId);

    void removeEquipment (Long equipmentId,Long instituteId);
    void removeEquipments (List<Long> equipmentIds,Long instituteId);

    void addEquipment (Long equipmentId,Long instituteId);
    void addEquipments (List<Long> equipmentIds,Long instituteId);

    void removeTeacher (Long teacherId,Long instituteId);
    void removeTeachers (List<Long> teacherIds,Long instituteId);

    void addTeacher (Long teacherId,Long instituteId);
    void addTeachers (List<Long> teacherIds,Long instituteId);

    List<TeacherDTO.Info> getUnAttachedTeachers(Long instituteId, Pageable pageable);
    Integer getUnAttachedTeachersCount(Long instituteId);

    List<EquipmentDTO.Info> getUnAttachedEquipments(Long instituteId, Pageable pageable);
    Integer getUnAttachedEquipmentsCount(Long instituteId);
}
