package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationOrientationService;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.repository.EducationOrientationDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationOrientationService implements IEducationOrientationService {

    private final ModelMapper modelMapper;
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
        return save(educationOrientation);
    }

    @Transactional
    @Override
    public EducationOrientationDTO.Info update(Long id, EducationOrientationDTO.Update request) {
        final Optional<EducationOrientation> cById = educationOrientationDAO.findById(id);
        final EducationOrientation educationOrientation = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        EducationOrientation updating = new EducationOrientation();
        modelMapper.map(educationOrientation, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationOrientation> one = educationOrientationDAO.findById(id);
        final EducationOrientation educationOrientation = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        educationOrientationDAO.delete(educationOrientation);
    }

    @Transactional
    @Override
    public void delete(EducationOrientationDTO.Delete request) {
        final List<EducationOrientation> gAllById = educationOrientationDAO.findAllById(request.getIds());
        educationOrientationDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationOrientationDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationOrientationDAO, request, educationOrientation -> modelMapper.map(educationOrientation, EducationOrientationDTO.Info.class));
    }   

    // ------------------------------

    private EducationOrientationDTO.Info save(EducationOrientation educationOrientation) {
        final EducationOrientation saved = educationOrientationDAO.saveAndFlush(educationOrientation);
        return modelMapper.map(saved, EducationOrientationDTO.Info.class);
    }


}
