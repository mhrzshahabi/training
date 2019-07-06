package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.SkillStandardDTO;
import com.nicico.training.iservice.ISkillStandardService;
import com.nicico.training.model.Course;
import com.nicico.training.model.SkillStandard;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.SkillStandardDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class SkillStandardService implements ISkillStandardService {

	private final ModelMapper modelMapper;
	private final SkillStandardDAO skillStandardDAO;
	private final CourseDAO courseDAO;

	@Transactional(readOnly = true)
	@Override
	public SkillStandardDTO.Info get(Long id) {
		final Optional<SkillStandard> ssById = skillStandardDAO.findById(id);
		final SkillStandard skillStandard = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardNotFound));
		return modelMapper.map(skillStandard, SkillStandardDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<SkillStandardDTO.Info> list() {
		final List<SkillStandard> ssAll = skillStandardDAO.findAll();
		return modelMapper.map(ssAll, new TypeToken<List<SkillStandardDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public SkillStandardDTO.Info create(SkillStandardDTO.Create request) {
		final SkillStandard skillStandard = modelMapper.map(request, SkillStandard.class);
		return save(skillStandard, request.getCourseIds());
	}

	@Transactional
	@Override
	public SkillStandardDTO.Info update(Long id, SkillStandardDTO.Update request) {
		final Optional<SkillStandard> ssById = skillStandardDAO.findById(id);
		final SkillStandard skillStandard = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardNotFound));

		SkillStandard updating = new SkillStandard();
		modelMapper.map(skillStandard, updating);
		modelMapper.map(request, updating);
		return save(updating, request.getCourseIds());
	}

	@Transactional
	@Override
	public void delete(Long id) {
		skillStandardDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(SkillStandardDTO.Delete request) {
		final List<SkillStandard> ssAllById = skillStandardDAO.findAllById(request.getIds());
		skillStandardDAO.deleteAll(ssAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<SkillStandardDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(skillStandardDAO, request, skillStandard -> modelMapper.map(skillStandard, SkillStandardDTO.Info.class));
	}

	// ---------------

	private SkillStandardDTO.Info save(SkillStandard skillStandard, Set<Long> courseIds) {
		final Set<Course> courses = new HashSet<>();
		Optional.ofNullable(courseIds)
				.ifPresent(courseIdSet -> courseIdSet
						.forEach(courseId ->
								courses.add(courseDAO.findById(courseId)
										.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound)))
						));
		skillStandard.setCourses(courses);

		final SkillStandard saved = skillStandardDAO.saveAndFlush(skillStandard);
		return modelMapper.map(saved, SkillStandardDTO.Info.class);
	}

	// ------------------------------

	@Transactional(readOnly = true)
	@Override
	public Set<CourseDTO.Info> getCourses(Long skillStandardId) {
		final Optional<SkillStandard> ssById = skillStandardDAO.findById(skillStandardId);
		final SkillStandard skillStandard = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardNotFound));

		Set<CourseDTO.Info> courseInfoSet = new HashSet<>();
		Optional.ofNullable(skillStandard.getCourses())
				.ifPresent(courses ->
						courses.forEach(course ->
								courseInfoSet.add(modelMapper.map(course, CourseDTO.Info.class))
						));

		return courseInfoSet;
	}
}
