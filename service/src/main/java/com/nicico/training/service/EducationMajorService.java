package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationMajorDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationMajorService;
import com.nicico.training.model.EducationMajor;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.repository.EducationMajorDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.academicBK.ElsEducationMajorDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationMajorService implements IEducationMajorService {

    private final ModelMapper modelMapper;
    private final EducationMajorDAO educationMajorDAO;

    @Transactional(readOnly = true)
    @Override
    public EducationMajorDTO.Info get(Long id) {
        final Optional<EducationMajor> gById = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationMajorNotFound));
        return modelMapper.map(educationMajor, EducationMajorDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EducationMajorDTO.Info> list() {
        final List<EducationMajor> gAll = educationMajorDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<EducationMajorDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EducationMajorDTO.Info create(EducationMajorDTO.Create request) {
        final EducationMajor educationMajor = modelMapper.map(request, EducationMajor.class);
//        if (educationMajorDAO.findByTitleFa(educationMajor.getTitleFa()).isEmpty())
//            return save(educationMajor);
//        else
//            return null;
        try {
            return save(educationMajor);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public EducationMajorDTO.Info update(Long id, EducationMajorDTO.Update request) {
        final Optional<EducationMajor> cById = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationMajorNotFound));
//        if (request.getTitleFa() != null) {
//            List<EducationMajor> byTitleFa = educationMajorDAO.findByTitleFa(request.getTitleFa());
//            if (byTitleFa.size() > 1)
//                return null;
//            if (byTitleFa.size() == 1 && !Objects.equals(educationMajor.getId(), byTitleFa.get(0).getId()))
//                return null;
//        }
        EducationMajor updating = new EducationMajor();
        modelMapper.map(educationMajor, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationMajor> one = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationMajorNotFound));
//        if (educationMajor.getPersonalInfoList().isEmpty() && educationMajor.getEducationOrientationList().isEmpty()) {
//            educationMajorDAO.delete(educationMajor);
//            return true;
//        } else {
//            return false;
//        }
        try {
            educationMajorDAO.delete(educationMajor);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(EducationMajorDTO.Delete request) {
        final List<EducationMajor> gAllById = educationMajorDAO.findAllById(request.getIds());
        for (EducationMajor educationMajor : gAllById) {
            if (!educationMajor.getPersonalInfoList().isEmpty() || !educationMajor.getEducationOrientationList().isEmpty())
                gAllById.remove(educationMajor);
        }
        educationMajorDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationMajorDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationMajorDAO, request, educationMajor -> modelMapper.map(educationMajor, EducationMajorDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<ElsEducationMajorDto> elsEducationMajorList() {
        final List<EducationMajor> gAll = educationMajorDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<ElsEducationMajorDto>>() {
        }.getType());
    }

    @Override
    public ElsEducationMajorDto elsEducationMajor(Long id) {
        final Optional<EducationMajor> gById = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationMajorNotFound));
        return modelMapper.map(educationMajor, ElsEducationMajorDto.class);
    }

    private EducationMajorDTO.Info save(EducationMajor educationMajor) {
        final EducationMajor saved = educationMajorDAO.saveAndFlush(educationMajor);
        return modelMapper.map(saved, EducationMajorDTO.Info.class);
    }

    @Transactional
    @Override
    public List<EducationOrientationDTO.Info> listByMajorId(Long majorId) {
        final Optional<EducationMajor> cById = educationMajorDAO.findById(majorId);
        final EducationMajor one = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationMajorNotFound));
        List<EducationOrientation> educationOrientations = one.getEducationOrientationList();
        List<EducationOrientationDTO.Info> eduOrientationInfo = new ArrayList<>();
        Optional.ofNullable(educationOrientations)
                .ifPresent(skills ->
                        skills.forEach(eduOrient ->
                                eduOrientationInfo.add(modelMapper.map(eduOrient, EducationOrientationDTO.Info.class))
                        ));
        return eduOrientationInfo;
    }
}
