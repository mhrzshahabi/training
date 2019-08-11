package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SkillStandardGroupDTO;
import com.nicico.training.iservice.ISkillStandardGroupService;
import com.nicico.training.model.SkillGroup;
import com.nicico.training.model.SkillStandard;
import com.nicico.training.repository.SkillStandardDAO;
import com.nicico.training.repository.SkillStandardGroupDAO;
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
public class SkillStandardGroupService implements ISkillStandardGroupService {

	private final ModelMapper modelMapper;
	private final SkillStandardGroupDAO skillStandardGroupDAO;
	private final SkillStandardDAO skillStandardDAO;

	@Transactional(readOnly = true)
	@Override
	public SkillStandardGroupDTO.Info get(Long id) {
		final Optional<SkillGroup> ssgById = skillStandardGroupDAO.findById(id);
		final SkillGroup skillGroup = ssgById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardGroupNotFound));

		return modelMapper.map(skillGroup, SkillStandardGroupDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<SkillStandardGroupDTO.Info> list() {
		List<SkillGroup> ssgAll = skillStandardGroupDAO.findAll();

		return modelMapper.map(ssgAll, new TypeToken<List<SkillStandardGroupDTO.Info>>() {
		}.getType());

	}

	@Transactional
	@Override
	public SkillStandardGroupDTO.Info create(SkillStandardGroupDTO.Create request) {
		final SkillGroup skillGroup = modelMapper.map(request, SkillGroup.class);

		return save(skillGroup, request.getSkillStandardIds());
	}

	@Transactional
	@Override
	public SkillStandardGroupDTO.Info update(Long id, SkillStandardGroupDTO.Update request) {
		final Optional<SkillGroup> ssgById = skillStandardGroupDAO.findById(id);
		final SkillGroup skillGroup = ssgById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardGroupNotFound));

		SkillGroup updating = new SkillGroup();
		modelMapper.map(skillGroup, updating);
		modelMapper.map(request, updating);

		return save(updating, request.getSkillStandardIds());
	}

	@Transactional
	@Override
	public void delete(Long id) {
		skillStandardGroupDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(SkillStandardGroupDTO.Delete request) {
		final List<SkillGroup> ssgAllById = skillStandardGroupDAO.findAllById(request.getIds());
		skillStandardGroupDAO.deleteAll(ssgAllById);

	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<SkillStandardGroupDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(skillStandardGroupDAO, request, skillGroup -> modelMapper.map(skillGroup, SkillStandardGroupDTO.Info.class));
	}

	// ------------------------------

	private SkillStandardGroupDTO.Info save(SkillGroup skillGroup, Set<Long> skillStandardIds) {
		final Set<SkillStandard> skillStandards = new HashSet<>();
		Optional.ofNullable(skillStandardIds)
				.ifPresent(skillStandardIdSet -> skillStandardIdSet
						.forEach(syllabusId ->
								skillStandards.add(skillStandardDAO.findById(syllabusId)
										.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardNotFound)))
						));
	//	skillGroup.setSkills(null);

		final SkillGroup saved = skillStandardGroupDAO.saveAndFlush(skillGroup);
		return modelMapper.map(saved, SkillStandardGroupDTO.Info.class);
	}
}
