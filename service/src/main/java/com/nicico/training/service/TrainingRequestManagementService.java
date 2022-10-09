package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ITrainingRequestManagementService;
import com.nicico.training.model.TrainingRequestManagement;
import com.nicico.training.repository.TrainingRequestManagementDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class TrainingRequestManagementService implements ITrainingRequestManagementService {

    private final TrainingRequestManagementDAO trainingRequestManagementDao;

    @Override
    public TrainingRequestManagement create(TrainingRequestManagement competenceRequest) {
        return trainingRequestManagementDao.save(competenceRequest);
    }

    @Override
    public TrainingRequestManagement update(TrainingRequestManagement newTrainingRequestManagement, Long id) {
        TrainingRequestManagement trainingRequestManagement=get(id);
        trainingRequestManagement.setApplicant(newTrainingRequestManagement.getApplicant());
        trainingRequestManagement.setLetterNumber(newTrainingRequestManagement.getLetterNumber());
        trainingRequestManagement.setRequestDate(newTrainingRequestManagement.getRequestDate());
        trainingRequestManagement.setAcceptor(newTrainingRequestManagement.getAcceptor());
        trainingRequestManagement.setComplex(newTrainingRequestManagement.getComplex());
        trainingRequestManagement.setDescription(newTrainingRequestManagement.getDescription());
        trainingRequestManagement.setLetterDate(newTrainingRequestManagement.getLetterDate());
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

}
