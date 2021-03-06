package com.nicico.training.mapper.ClassSession;


import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import response.tclass.ElsSessionDetailDto;
import response.tclass.ElsSessionResponse;
import response.tclass.dto.ElsSessionUsersDto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class SessionBeanMapper {

    @Autowired
    protected IClassSession iClassSession;

    public ElsSessionResponse toGetElsSessionResponse(Tclass tclass) {

        ElsSessionResponse elsSessionResponse = new ElsSessionResponse();
        List<ElsSessionUsersDto> elsSessionUsersDtos = new ArrayList<>();
        List<ElsSessionDetailDto> elsSessionDetailDtos = new ArrayList<>();

        tclass.getClassStudents().forEach(student -> {

            ElsSessionUsersDto elsSessionUsersDto = new ElsSessionUsersDto();
            elsSessionUsersDto.setUserId(student.getStudentId());
            elsSessionUsersDto.setNationalCode(student.getStudent().getNationalCode());
            elsSessionUsersDto.setFullName(student.getStudent().getFirstName() + " " + student.getStudent().getLastName());

            elsSessionUsersDtos.add(elsSessionUsersDto);
        });

        tclass.getClassSessions().forEach(session -> {

            Calendar calendar = Calendar.getInstance();
            Date gregorianSessionDate = convertToGregorianDate(session.getSessionDate());
            calendar.setTime(gregorianSessionDate);

            ElsSessionDetailDto elsSessionDetailDto = new ElsSessionDetailDto();
            elsSessionDetailDto.setSessionId(session.getId());
            elsSessionDetailDto.setDay(session.getDayName());
            elsSessionDetailDto.setStartTime(session.getSessionStartHour());
            elsSessionDetailDto.setEndTime(session.getSessionEndHour());
            elsSessionDetailDto.setDateOfHolding(calendar.getTime().getTime());
            elsSessionDetailDto.setAttendances(iClassSession.getSessionPresenceState(session));
            elsSessionDetailDto.setTeacherAttendancePermission(session.getTeacherAttendancePermission());

            elsSessionDetailDtos.add(elsSessionDetailDto);
        });
        elsSessionDetailDtos.sort(Comparator.comparing(ElsSessionDetailDto::getDateOfHolding));

        elsSessionResponse.setCode(tclass.getCode());
        elsSessionResponse.setUsers(elsSessionUsersDtos);
        elsSessionResponse.setSessions(elsSessionDetailDtos);
        return elsSessionResponse;
    }

    protected Date convertToGregorianDate(String jalaliDate) {

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        try {
            return formatter.parse(DateUtil.convertKhToMi1(jalaliDate));
        } catch (ParseException e) {
            throw new TrainingException(TrainingException.ErrorType.Unknown);
        }
    }

}
