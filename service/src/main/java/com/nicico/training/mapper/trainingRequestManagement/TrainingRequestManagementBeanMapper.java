package com.nicico.training.mapper.trainingRequestManagement;


 import com.nicico.training.dto.TrainingRequestManagementDTO;
 import com.nicico.training.model.TrainingRequestItem;
 import com.nicico.training.model.TrainingRequestManagement;
 import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
 import org.mapstruct.ReportingPolicy;

 import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TrainingRequestManagementBeanMapper {

    TrainingRequestManagement toTrainingRequestManagement (TrainingRequestManagementDTO.Create request);

    TrainingRequestManagement toTrainingRequestManagement (TrainingRequestManagementDTO.Update request);

    TrainingRequestManagementDTO.Info toTrainingRequestManagementDto(TrainingRequestManagement trainingRequestManagement);

    @Mapping(target = "name",source = "personnel.firstName")
    @Mapping(target = "lastName",source = "personnel.lastName")
    @Mapping(target = "nationalCode",source = "personnel.nationalCode")
    @Mapping(target = "currentPostTitle",source = "personnel.postTitle")
    @Mapping(target = "currentPostCode",source = "personnel.postCode")
    @Mapping(target = "personnelNo2",source = "personnel.personnelNo2")
    @Mapping(target = "personnelNo",source = "personnel.personnelNo")
    @Mapping(target = "nextPostCode",source = "post.code")
    @Mapping(target = "nextPostTitle",source = "post.titleFa")
    @Mapping(target = "postId",source = "post.id")
    @Mapping(target = "personnelId",source = "personnel.id")
    TrainingRequestManagementDTO.PositionAppointmentInfo toTrainingReqPositionAppointmentDto(TrainingRequestItem trainingReqPositionAppointment);



    List<TrainingRequestManagementDTO.Info> toTrainingRequestManagementDTOs(List<TrainingRequestManagement> trainingRequestManagementList);
    List<TrainingRequestManagementDTO.PositionAppointmentInfo> toTrainingReqPositionAppointmentDtos(List<TrainingRequestItem> trainingReqPositionAppointmentList);
}
