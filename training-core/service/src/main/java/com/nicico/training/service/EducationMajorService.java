package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EducationMajorDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.iservice.IEducationMajorService;
import com.nicico.training.model.EducationMajor;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.model.Skill;
import com.nicico.training.repository.EducationMajorDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        return save(educationMajor);
    }

    @Transactional
    @Override
    public EducationMajorDTO.Info update(Long id, EducationMajorDTO.Update request) {
        final Optional<EducationMajor> cById = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        EducationMajor updating = new EducationMajor();
        modelMapper.map(educationMajor, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<EducationMajor> one = educationMajorDAO.findById(id);
        final EducationMajor educationMajor = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        educationMajorDAO.delete(educationMajor);
    }

    @Transactional
    @Override
    public void delete(EducationMajorDTO.Delete request) {
        final List<EducationMajor> gAllById = educationMajorDAO.findAllById(request.getIds());
        educationMajorDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EducationMajorDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(educationMajorDAO, request, educationMajor -> modelMapper.map(educationMajor, EducationMajorDTO.Info.class));
    }   

    // ------------------------------

    private EducationMajorDTO.Info save(EducationMajor educationMajor) {
        final EducationMajor saved = educationMajorDAO.saveAndFlush(educationMajor);
        return modelMapper.map(saved, EducationMajorDTO.Info.class);
    }

    @Transactional
    @Override
    public List<EducationOrientationDTO.Info> listByMajorId(Long majorId) {
        final Optional<EducationMajor> cById = educationMajorDAO.findById(majorId);
        final EducationMajor one = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
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
