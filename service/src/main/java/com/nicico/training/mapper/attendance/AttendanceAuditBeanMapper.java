package com.nicico.training.mapper.attendance;

import com.nicico.training.dto.AttendanceAuditDTO;
import com.nicico.training.model.AttendanceAudit;
import com.nicico.training.model.compositeKey.AuditAttendanceId;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface AttendanceAuditBeanMapper {

    List<AttendanceAuditDTO.Info> toAttendanceAuditInfoDTOList(List<AttendanceAudit> attendanceAuditList);

    @Mapping(target = "id", source = "id" , qualifiedByName = "getAttendanceIdFromAudit")
    AttendanceAuditDTO.Info toAttendanceAuditInfoDTO(AttendanceAudit attendanceAudit);


    @Named("getAttendanceIdFromAudit")
    default Long getAttendanceIdFromAudit(AuditAttendanceId auditAttendance){
       return auditAttendance.getId();
    }
}
