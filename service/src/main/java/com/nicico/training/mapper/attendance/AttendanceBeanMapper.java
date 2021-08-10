package com.nicico.training.mapper.attendance;

import com.nicico.training.model.Attendance;
import com.nicico.training.model.Student;
import dto.evaluuation.EvalTargetUser;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import request.attendance.AttendanceListSaveRequest;
import request.attendance.ElsTeacherAttendanceListSaveDto;
import request.attendance.dto.AttendanceDto;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface AttendanceBeanMapper {

    @Mapping(source = "sessionId", target = "sessionId")
    @Mapping(source = "studentId", target = "studentId")
    @Mapping(source = "state", target = "state")
    @Mapping(source = "description", target = "description")
    Attendance toAttendance(AttendanceDto attendanceDto);

    default List<Attendance> ToAttendanceList(AttendanceListSaveRequest requestList) {
        return requestList.getAttendanceDtos().stream().map(this::toAttendance).collect(Collectors.toList());
    }

     List<Attendance> elsToAttendanceList(List<AttendanceDto> attendanceDtos);

    @Mapping(target = "surname", source = "firstName")
    @Mapping(target = "lastName", source = "lastName")
    @Mapping(target = "nationalCode", source = "nationalCode")
    EvalTargetUser toTargetUser(Student student);

    List<EvalTargetUser> toTargetUsers(List<Student> students);
}
