package com.nicico.training.iservice;


 import com.nicico.copper.common.dto.search.SearchDTO;
 import com.nicico.training.model.TrainingRequestItem;

 import java.util.List;


public interface ITrainingReqItemService {

    TrainingRequestItem create(TrainingRequestItem trainingReqPositionAppointment);


    List<TrainingRequestItem> search(SearchDTO.SearchRq request);

    TrainingRequestItem get(Long positionAppointmentId);

    void delete(TrainingRequestItem positionAppointment);

    Integer getTotalCount(Long id,String ref);
}
