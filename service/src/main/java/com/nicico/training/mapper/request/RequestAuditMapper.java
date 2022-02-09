package com.nicico.training.mapper.request;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.TimeZone;
import com.ibm.icu.util.ULocale;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.RequestAudit;
import com.nicico.training.model.TClassAudit;
import com.nicico.training.utility.persianDate.PersianDate;
import org.mapstruct.*;

import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface RequestAuditMapper {
     @Mappings({
             @Mapping(target = "createdDate",source = "createdDate",qualifiedByName = "convertToTrainingPersianDate"),
             @Mapping(target ="lastModifiedDate" ,source = "lastModifiedDate",qualifiedByName ="convertToTrainingPersianDate" ),
             @Mapping(target="status",source="requestStatus")

     })
     RequestResVM.InfoForAudit toDTO(RequestAudit requestAudit);
     List<RequestResVM.InfoForAudit> toRequestResponse(List<RequestAudit> requestAudits);
     @Named("convertToTrainingPersianDate")
     default String convertToTrainingPersianDate(Date _date) {
          Long date = _date.getTime();
          ULocale PERSIAN_LOCALE = new ULocale("fa_IR");
          ZoneId IRAN_ZONE_ID = ZoneId.of("Asia/Tehran");

          SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd", PERSIAN_LOCALE );
          df.setTimeZone(TimeZone.getTimeZone("GMT+3:30"));
          return df.format(date);
     }
}
