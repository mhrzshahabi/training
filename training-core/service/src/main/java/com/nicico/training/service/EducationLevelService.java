package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationLevelDTO;
import com.nicico.training.iservice.IEducationLevelService;
import com.nicico.training.model.EducationLevel;
import com.nicico.training.repository.EducationLevelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EducationLevelService implements IEducationLevelService {

    private final ModelMapper modelMapper;
    private final EducationLevelDAO educationLevelDAO;

    @Transactional(readOnly = true)
    @Override
    public EducationLevelDTO.Info get(Long id) {
        final Optional<EducationLevel> gById = educationLevelDAO.findById(id);
        final EducationLevel educationLevel = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EducationLevelNotFound));
        return modelMapper.map(educationLevel, EducationLevelDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EducationLevelDTO.Info> list() {
        final List<EducationLevel> gAll = educationLevelDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<EducationLevelDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EducationLevelDTO.Info create(EducationLevelDTO.Create request) {
        final EducationLevel educationLevel = modelMapper.map(request, EducationLevel.class);
        return save(educationLevel);
    }

    @Transactional
    @Override
    public EducationLevelDTO.Info update(Long id, EducationLevelDTO.Update request) {
        final Optional<EducationLevel> cById = educationLevelDAO.findById(id);
        final EducationLevel educationLevel = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        EducationLevel updating = new EducationLevel();
        modelMapper.map(educationLevel, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationLevel> one = educationLevelDAO.findById(id);
        final EducationLevel educationLevel = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        educationLevelDAO.delete(educationLevel);
    }

    @Transactional
    @Override
    public void delete(EducationLevelDTO.Delete request) {
        final List<EducationLevel> gAllById = educationLevelDAO.findAllById(request.getIds());
        educationLevelDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationLevelDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationLevelDAO, request, educationLevel -> modelMapper.map(educationLevel, EducationLevelDTO.Info.class));
    }   

    // ------------------------------

    private EducationLevelDTO.Info save(EducationLevel educationLevel) {
        final EducationLevel saved = educationLevelDAO.saveAndFlush(educationLevel);
        return modelMapper.map(saved, EducationLevelDTO.Info.class);
    }
}
