package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ITrainingReqItemService;
 import com.nicico.training.model.TrainingRequestItem;
import com.nicico.training.repository.TrainingReqItemDAO;
 import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
@RequiredArgsConstructor
public class TrainingReqPositionAppointmentService implements ITrainingReqItemService {

    private final TrainingReqItemDAO trainingReqPositionAppointmentDAO;

    @Override
    public TrainingRequestItem create(TrainingRequestItem trainingReqPositionAppointment) {
        return trainingReqPositionAppointmentDAO.save(trainingReqPositionAppointment);
    }

    @Override
    public List<TrainingRequestItem> search(SearchDTO.SearchRq request) {
        if (request.getStartIndex() != null) {
            Page<TrainingRequestItem> all = trainingReqPositionAppointmentDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            return all.getContent();
        } else {
            return trainingReqPositionAppointmentDAO.findAll(NICICOSpecification.of(request));
        }
    }

    @Override
    public TrainingRequestItem get(Long positionAppointmentId) {
        return trainingReqPositionAppointmentDAO.findById(positionAppointmentId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }


    @Override
    public Integer getTotalCount(Long id,String ref) {
        return Math.toIntExact(trainingReqPositionAppointmentDAO.findAllByRefAndTrainingRequestManagementId(ref,id).size());
    }


    @Override
    @Transactional
    public void delete(TrainingRequestItem positionAppointment) {
        trainingReqPositionAppointmentDAO.delete(positionAppointment);
    }


}
