package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.CustomModelMapper;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationOrientationService;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.repository.EducationOrientationDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.academicBK.ElsEducationOrientationDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationOrientationService implements IEducationOrientationService {

    private final CustomModelMapper modelMapper;
    private final EducationOrientationDAO educationOrientationDAO;

    @Transactional(readOnly = true)
    @Override
    public EducationOrientationDTO.Info get(Long id) {
        final Optional<EducationOrientation> gById = educationOrientationDAO.findById(id);
        final EducationOrientation educationOrientation = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationOrientationNotFound));
        return modelMapper.map(educationOrientation, EducationOrientationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EducationOrientationDTO.Info> list() {
        final List<EducationOrientation> gAll = educationOrientationDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<EducationOrientationDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EducationOrientationDTO.Info create(EducationOrientationDTO.Create request) {
        final EducationOrientation educationOrientation = modelMapper.map(request, EducationOrientation.class);
        try {
            return save(educationOrientation);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
//        if (educationOrientationDAO.findByTitleFaAndEducationLevelIdAAndEducationMajorId(
//                educationOrientation.getTitleFa(),
//                educationOrientation.getEducationLevelId(),
//                educationOrientation.getEducationMajorId()).isEmpty())
//            return save(educationOrientation);
//        else
//            return null;
    }

    @Transactional
    @Override
    public EducationOrientationDTO.Info update(Long id, EducationOrientationDTO.Update request) {
        final Optional<EducationOrientation> cById = educationOrientationDAO.findById(id);
        final EducationOrientation educationOrientation = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationOrientationNotFound));

        if (!Objects.equals(request.getEducationLevelId(), educationOrientation.getEducationLevelId()) ||
                !Objects.equals(request.getEducationMajorId(), educationOrientation.getEducationMajorId()))
            if (!educationOrientation.getPersonalInfoList().isEmpty())
                throw new TrainingException(TrainingException.ErrorType.NotEditable);

        EducationOrientation updating = new EducationOrientation();
        modelMapper.map(educationOrientation, updating);
        modelMapper.map(request, updating);

//        List<EducationOrientation> orientationList = educationOrientationDAO.findByTitleFaAndEducationLevelIdAAndEducationMajorId(
//                updating.getTitleFa(),
//                updating.getEducationLevelId(),
//                updating.getEducationMajorId());
//        if (orientationList.size() > 1)
//            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
//        if (orientationList.size() == 1 && !Objects.equals(educationOrientation.getId(), orientationList.get(0).getId()))
//            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationOrientation> one = educationOrientationDAO.findById(id);
        final EducationOrientation educationOrientation = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationOrientationNotFound));
        try {
            educationOrientationDAO.delete(educationOrientation);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(EducationOrientationDTO.Delete request) {
        final List<EducationOrientation> gAllById = educationOrientationDAO.findAllById(request.getIds());
        for (EducationOrientation educationOrientation : gAllById) {
            if (!educationOrientation.getPersonalInfoList().isEmpty())
                gAllById.remove(educationOrientation);
        }
        educationOrientationDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationOrientationDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationOrientationDAO, request, educationOrientation -> modelMapper.map(educationOrientation, EducationOrientationDTO.Info.class));
    }

    private EducationOrientationDTO.Info save(EducationOrientation educationOrientation) {
        final EducationOrientation saved = educationOrientationDAO.saveAndFlush(educationOrientation);
        return modelMapper.map(saved, EducationOrientationDTO.Info.class);
    }

    @Transactional
    @Override
    public List<EducationOrientationDTO.Info> listByLevelIdAndMajorId(Long levelId, Long majorId) {
        List<EducationOrientation> educationOrientations = educationOrientationDAO.listByLevelIdAndMajorId(levelId, majorId);
        List<EducationOrientationDTO.Info> eduOrientationInfo = new ArrayList<>();
        for (EducationOrientation eduOrient : educationOrientations) {
            eduOrientationInfo.add(modelMapper.map(eduOrient, EducationOrientationDTO.Info.class));
        }
        return eduOrientationInfo;
    }

    @Transactional(readOnly = true)
    @Override
    public List<ElsEducationOrientationDto> elsEducationOrientationList(Long levelId, Long majorId) {
        List<EducationOrientation> educationOrientations = educationOrientationDAO.listByLevelIdAndMajorId(levelId, majorId);
        List<ElsEducationOrientationDto> elsEducationOrientationDtoList = new ArrayList<>();
        for (EducationOrientation eduOrient : educationOrientations) {
            elsEducationOrientationDtoList.add(modelMapper.map(eduOrient, ElsEducationOrientationDto.class));
        }
        return elsEducationOrientationDtoList;
    }

}
