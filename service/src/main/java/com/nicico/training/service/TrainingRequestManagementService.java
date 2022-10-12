package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TrainingRequestManagementDTO;
import com.nicico.training.iservice.ITrainingReqItemService;
import com.nicico.training.iservice.ITrainingRequestManagementService;
import com.nicico.training.model.TrainingRequestItem;
import com.nicico.training.model.TrainingRequestManagement;
import com.nicico.training.repository.TrainingRequestManagementDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.List;


@Service
@RequiredArgsConstructor
public class TrainingRequestManagementService implements ITrainingRequestManagementService {

    private final TrainingRequestManagementDAO trainingRequestManagementDao;
    private final ITrainingReqItemService trainingReqPositionAppointmentService;

    @Override
    public TrainingRequestManagement create(TrainingRequestManagement competenceRequest) {
        return trainingRequestManagementDao.save(competenceRequest);
    }

    @Override
    public TrainingRequestManagement update(TrainingRequestManagement newTrainingRequestManagement, Long id) {
        TrainingRequestManagement trainingRequestManagement = get(id);
        trainingRequestManagement.setApplicant(newTrainingRequestManagement.getApplicant());
        trainingRequestManagement.setLetterNumber(newTrainingRequestManagement.getLetterNumber());
        trainingRequestManagement.setAcceptor(newTrainingRequestManagement.getAcceptor());
        trainingRequestManagement.setComplex(newTrainingRequestManagement.getComplex());
        trainingRequestManagement.setDescription(newTrainingRequestManagement.getDescription());
        trainingRequestManagement.setTitle(newTrainingRequestManagement.getTitle());
        return create(trainingRequestManagement);
    }

    //
    @Override
    public TrainingRequestManagement get(Long id) {
        return trainingRequestManagementDao.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    //
    @Override
    public void delete(Long id) {
        trainingRequestManagementDao.deleteById(id);
    }

    //
    @Override
    public List<TrainingRequestManagement> getList() {
        return trainingRequestManagementDao.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(trainingRequestManagementDao.count());
    }



    //
    @Override
    public List<TrainingRequestManagement> search(SearchDTO.SearchRq request) {
        if (request.getStartIndex() != null) {
            Page<TrainingRequestManagement> all = trainingRequestManagementDao.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            return all.getContent();
        } else {
            return trainingRequestManagementDao.findAll(NICICOSpecification.of(request));
        }

    }

    @Override
    public BaseResponse addChild(TrainingRequestManagementDTO.CreatePositionAppointment request) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            TrainingRequestManagement trainingRequestManagement = get(request.getReqId());
            List<TrainingRequestItem> trainingReqPositionAppointmentList = trainingRequestManagement.getItems();
            if (trainingReqPositionAppointmentList.size() > 0 && trainingReqPositionAppointmentList.stream().anyMatch(a -> a.getPostId().equals(request.getPostId()) && a.getPersonnelId().equals(request.getPersonnelId())
                    && a.getRef().equals(request.getRef()) )) {
                baseResponse.setStatus(404);
                baseResponse.setMessage("فرد مورد نظر برای این پست در لیست موجود است");
            } else {
                TrainingRequestItem trainingReqPositionAppointment = new TrainingRequestItem();
                trainingReqPositionAppointment.setPersonnelId(request.getPersonnelId());
                trainingReqPositionAppointment.setPostId(request.getPostId());
                trainingReqPositionAppointment.setRef(request.getRef());
                trainingReqPositionAppointment.setTrainingRequestManagementId(trainingRequestManagement.getId());
                TrainingRequestItem savedPositionAppointment = trainingReqPositionAppointmentService.create(trainingReqPositionAppointment);
                trainingReqPositionAppointmentList.add(savedPositionAppointment);
                trainingRequestManagementDao.save(trainingRequestManagement);
                baseResponse.setStatus(200);
            }
            return baseResponse;
        } catch (Exception e) {
            baseResponse.setStatus(404);
            baseResponse.setMessage("خطا در اضافه کردن مورد جدید ");
            return baseResponse;

        }

    }

    @Override
    public List<TrainingRequestItem> searchPositionAppointment(SearchDTO.SearchRq request) {
        return trainingReqPositionAppointmentService.search(request);
    }

    @Override
    @Transactional
    public BaseResponse deleteChild( Long requestTrainingId,  Long positionAppointmentId) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            TrainingRequestManagement trainingRequestManagement = get(requestTrainingId);
            List<TrainingRequestItem> trainingReqPositionAppointmentList = trainingRequestManagement.getItems();

            TrainingRequestItem positionAppointment = trainingReqPositionAppointmentService.get(positionAppointmentId);
            trainingReqPositionAppointmentService.delete(positionAppointment);
            trainingReqPositionAppointmentList.remove(positionAppointment);
            trainingRequestManagement.setItems(trainingReqPositionAppointmentList);
            trainingRequestManagementDao.save(trainingRequestManagement);
            baseResponse.setStatus(200);
            return baseResponse;
        } catch (Exception e) {
            baseResponse.setStatus(404);
            baseResponse.setMessage("خطا در حذف کردن مورد  ");
            return baseResponse;

        }

    }

}
