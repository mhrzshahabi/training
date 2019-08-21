package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TrainingPlaceDTO;
import com.nicico.training.iservice.ITrainingPlaceService;
import com.nicico.training.model.Equipment;
import com.nicico.training.model.Institute;
import com.nicico.training.model.TrainingPlace;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.EquipmentDAO;
import com.nicico.training.repository.InstituteDAO;
import com.nicico.training.repository.TrainingPlaceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TrainingPlaceService implements ITrainingPlaceService {
    private final ModelMapper modelMapper;
    private final TrainingPlaceDAO trainingPlaceDAO;
    private final EquipmentDAO equipmentDAO;
    private final InstituteDAO instituteDAO;
    private final EnumsConverter.EPlaceTypeConverter ePlaceTypeConverter=new EnumsConverter.EPlaceTypeConverter();
    private final EnumsConverter.EArrangementTypeConverter eArrangementTypeConverter=new EnumsConverter.EArrangementTypeConverter();


    @Transactional(readOnly = true)
    @Override
    public TrainingPlaceDTO.Info get(Long id) {
        final Optional<TrainingPlace> gById = trainingPlaceDAO.findById(id);
        final TrainingPlace trainingPlace = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPlaceNotFound));
        return modelMapper.map(trainingPlace, TrainingPlaceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<TrainingPlaceDTO.Info> list() {
        final List<TrainingPlace> gAll = trainingPlaceDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<TrainingPlaceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public TrainingPlaceDTO.Info create(TrainingPlaceDTO.Create request) {
        final TrainingPlace trainingPlace = modelMapper.map(request, TrainingPlace.class);
        if(request.getEPlaceTypeId() != null) {
            trainingPlace.setEPlaceType(ePlaceTypeConverter.convertToEntityAttribute(request.getEPlaceTypeId()));
        }
        if(request.getEArrangementTypeId() != null) {
            trainingPlace.setEArrangementType(eArrangementTypeConverter.convertToEntityAttribute(request.getEArrangementTypeId()));
        }
        return save(trainingPlace,request.getEquipmentIds());
    }

    @Transactional
    @Override
    public TrainingPlaceDTO.Info update(Long id, TrainingPlaceDTO.Update request) {
        final Optional<TrainingPlace> cById = trainingPlaceDAO.findById(id);
        final TrainingPlace trainingPlace = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPlaceNotFound));
        TrainingPlace updating = new TrainingPlace();
        modelMapper.map(trainingPlace, updating);
        modelMapper.map(request, updating);
        if(request.getEPlaceTypeId() != null) {
            trainingPlace.setEPlaceType(ePlaceTypeConverter.convertToEntityAttribute(request.getEPlaceTypeId()));
        }
        if(request.getEArrangementTypeId() != null) {
            trainingPlace.setEArrangementType(eArrangementTypeConverter.convertToEntityAttribute(request.getEArrangementTypeId()));
        }

        return modelMapper.map(trainingPlaceDAO.saveAndFlush(updating), TrainingPlaceDTO.Info.class);
    }


    @Transactional
    @Override
    public void delete(Long id) {
        trainingPlaceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(TrainingPlaceDTO.Delete request) {
        final List<TrainingPlace> gAllById = trainingPlaceDAO.findAllById(request.getIds());
        trainingPlaceDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TrainingPlaceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(trainingPlaceDAO, request, trainingPlace -> modelMapper.map(trainingPlace, TrainingPlaceDTO.Info.class));
    }

    // ------------------------------

    private TrainingPlaceDTO.Info save(TrainingPlace trainingPlace,Set<Long> equipmentIds) {
        final Set<Equipment> equipmentSet=new HashSet<>();

        Optional.ofNullable(equipmentIds)
                .ifPresent(equipmentIdSet->equipmentIdSet
                        .forEach(equipmentId->equipmentSet.add(equipmentDAO.findById(equipmentId).orElseThrow(()->new TrainingException(TrainingException.ErrorType.EquipmentNotFound)))));
        final Optional<Institute> optionalInstitute = instituteDAO.findById(trainingPlace.getInstituteId());
        final Institute institute=optionalInstitute.orElseThrow(()->new TrainingException(TrainingException.ErrorType.InstituteNotFound));

        trainingPlace.setInstitute(institute);
        trainingPlace.setEquipmentSet(equipmentSet);
        final TrainingPlace saved = trainingPlaceDAO.saveAndFlush(trainingPlace);
        return modelMapper.map(saved, TrainingPlaceDTO.Info.class);
    }



}
