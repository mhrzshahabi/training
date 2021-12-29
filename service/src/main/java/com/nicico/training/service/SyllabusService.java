package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.iservice.ISyllabusService;
import com.nicico.training.model.Course;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Syllabus;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.SyllabusDAO;
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
public class SyllabusService implements ISyllabusService {

    private final ModelMapper modelMapper;
    private final SyllabusDAO syllabusDAO;
    private final EnumsConverter.EDomainTypeConverter eDomainTypeConverter = new EnumsConverter.EDomainTypeConverter();
    private final CourseDAO courseDAO;

    @Transactional(readOnly = true)
    @Override
    public SyllabusDTO.Info get(Long id) {
        final Optional<Syllabus> sById = syllabusDAO.findById(id);
        final Syllabus syllabus = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        return modelMapper.map(syllabus, SyllabusDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<SyllabusDTO.Info> list() {
        final List<Syllabus> sAll = syllabusDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<SyllabusDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public SyllabusDTO.Info create(SyllabusDTO.Create request) {
        final Syllabus syllabus = modelMapper.map(request, Syllabus.class);
        syllabus.setEDomainType(eDomainTypeConverter.convertToEntityAttribute(request.getEDomainTypeId()));
        return save(syllabus);
    }

    @Transactional
    @Override
    public SyllabusDTO.Info update(Long id, SyllabusDTO.Update request) {
        final Optional<Syllabus> sById = syllabusDAO.findById(id);
        final Syllabus syllabus = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Syllabus updating = new Syllabus();
//		updating.setEDomainTypeId(eDomainTypeConverter.convertToEntityAttribute(request.getEDomainTypeId()));
        modelMapper.map(syllabus, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        syllabusDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(SyllabusDTO.Delete request) {
        final List<Syllabus> sAllById = syllabusDAO.findAllById(request.getIds());

        syllabusDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SyllabusDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(syllabusDAO, request, syllabus -> modelMapper.map(syllabus, SyllabusDTO.Info.class));
    }

    @Transactional
    @Override
    public List<SyllabusDTO.Info> getSyllabusCourse(Long courseId) {
        List<SyllabusDTO.Info> syllabusInfoTuples = new ArrayList<>();
        Course one = courseDAO.getById(courseId);
        List<Goal> goalSet = one.getGoalSet();
        for (Goal goal : goalSet) {
            Optional.ofNullable(goal.getSyllabusSet())
                    .ifPresent(syllabusSet ->
                            syllabusSet.forEach(syllabus ->
                                    syllabusInfoTuples.add(modelMapper.map(syllabus, SyllabusDTO.Info.class))
                            ));
        }
        return syllabusInfoTuples;
    }

    // ------------------------------

    private SyllabusDTO.Info save(Syllabus syllabus) {

        final Syllabus saved = syllabusDAO.saveAndFlush(syllabus);
        return modelMapper.map(saved, SyllabusDTO.Info.class);
    }
}
