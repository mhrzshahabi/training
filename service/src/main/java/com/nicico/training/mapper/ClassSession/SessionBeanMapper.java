package com.nicico.training.mapper.ClassSession;


import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import response.tclass.ElsSessionDetail;
import response.tclass.ElsSessionResponse;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class SessionBeanMapper {

    @Autowired
    protected IClassSession iClassSession;

    public ElsSessionResponse toGetElsSessionResponse(Tclass tclass) {

        ElsSessionResponse elsSessionResponse = new ElsSessionResponse();
        List<ElsSessionDetail> elsSessionDetails = new ArrayList<>();

        tclass.getClassSessions().forEach(session -> {

            Calendar calendar = Calendar.getInstance();
            Date gregorianSessionDate = convertToGregorianDate(session.getSessionDate());
            calendar.setTime(gregorianSessionDate);

            ElsSessionDetail elsSessionDetail = new ElsSessionDetail();
            elsSessionDetail.setDay(session.getDayName());
            elsSessionDetail.setStartTime(session.getSessionStartHour());
            elsSessionDetail.setEndTime(session.getSessionEndHour());
            elsSessionDetail.setDateOfHolding(calendar.getTime().getTime());
            elsSessionDetail.setAttendances(iClassSession.getSessionPresenceState(session));

            elsSessionDetails.add(elsSessionDetail);
        });

        elsSessionResponse.setCode(tclass.getCode());
        elsSessionResponse.setSessions(elsSessionDetails);
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
