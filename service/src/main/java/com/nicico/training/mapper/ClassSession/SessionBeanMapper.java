package com.nicico.training.mapper.ClassSession;


import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IClassSessionService;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.TeacherDAO;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import response.tclass.ElsSessionDetailDto;
import response.tclass.ElsSessionResponse;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class SessionBeanMapper {

    @Autowired
    protected IClassSessionService IClassSessionService;
    @Autowired
    protected TeacherDAO teacherDAO;

    public ElsSessionResponse toGetElsSessionResponse(Tclass tclass) {

        ElsSessionResponse elsSessionResponse = new ElsSessionResponse();
        List<String> studentsNationalCodes=new ArrayList<>();

        List<ElsSessionDetailDto> elsSessionDetailDtos = new ArrayList<>();
        if(tclass.getClassStudents()!=null) {
            tclass.getClassStudents().forEach(student -> {
                studentsNationalCodes.add(student.getStudent().getNationalCode());

            });
            elsSessionResponse.setStudentsNationalCodes(studentsNationalCodes);
        }
        Optional<Teacher> teacher = teacherDAO.findById(tclass.getTeacherId());
        if(teacher.isPresent())
         elsSessionResponse.setInstructorNationalCode(teacher.get().getTeacherCode());
        tclass.getClassSessions().forEach(session -> {

            Calendar calendar = Calendar.getInstance();
            Date gregorianSessionDate = convertToGregorianDate(session.getSessionDate());
            calendar.setTime(gregorianSessionDate);

            ElsSessionDetailDto elsSessionDetailDto = new ElsSessionDetailDto();
            elsSessionDetailDto.setClassId(session.getClassId());
            elsSessionDetailDto.setSessionId(session.getId());
            elsSessionDetailDto.setDay(session.getDayName());
            elsSessionDetailDto.setStartTime(session.getSessionStartHour());
            elsSessionDetailDto.setEndTime(session.getSessionEndHour());
            elsSessionDetailDto.setDateOfHolding(calendar.getTime().getTime());
            elsSessionDetailDto.setAttendances(IClassSessionService.getSessionPresenceState(session));
            elsSessionDetailDto.setTeacherAttendancePermission(session.getTeacherAttendancePermission());

            elsSessionDetailDtos.add(elsSessionDetailDto);
        });
        elsSessionDetailDtos.sort(Comparator.comparing(ElsSessionDetailDto::getDateOfHolding));

        elsSessionResponse.setCode(tclass.getCode());
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
