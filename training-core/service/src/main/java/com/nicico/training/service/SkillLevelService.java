package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SkillLevelDTO;
import com.nicico.training.iservice.ISkillLevelService;
import com.nicico.training.model.SkillLevel;
import com.nicico.training.repository.SkillLevelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class SkillLevelService implements ISkillLevelService {

	private final ModelMapper modelMapper;
	private final SkillLevelDAO skillLevelDAO;

	@Transactional(readOnly = true)
	@Override
	public SkillLevelDTO.Info get(Long id) {
		final Optional<SkillLevel> slById = skillLevelDAO.findById(id);
		final SkillLevel skillLevel = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillLevelNotFound));

		return modelMapper.map(skillLevel, SkillLevelDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<SkillLevelDTO.Info> list() {
		final List<SkillLevel> slAll = skillLevelDAO.findAll();

		return modelMapper.map(slAll, new TypeToken<List<SkillLevelDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public SkillLevelDTO.Info create(SkillLevelDTO.Create request) {
		final SkillLevel skillLevel = modelMapper.map(request, SkillLevel.class);

		return save(skillLevel);
	}

	@Transactional
	@Override
	public SkillLevelDTO.Info update(Long id, SkillLevelDTO.Update request) {
		final Optional<SkillLevel> slById = skillLevelDAO.findById(id);
		final SkillLevel skillLevel = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillLevelNotFound));

		SkillLevel updating = new SkillLevel();
		modelMapper.map(skillLevel, updating);
		modelMapper.map(request, updating);

		return save(updating);
	}

	@Transactional
	@Override
	public void delete(Long id) {
		skillLevelDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(SkillLevelDTO.Delete request) {
		final List<SkillLevel> slAllById = skillLevelDAO.findAllById(request.getIds());

		skillLevelDAO.deleteAll(slAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<SkillLevelDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(skillLevelDAO, request, skillLevel -> modelMapper.map(skillLevel, SkillLevelDTO.Info.class));
	}

	// ------------------------------

	private SkillLevelDTO.Info save(SkillLevel skillLevel) {
		final SkillLevel saved = skillLevelDAO.saveAndFlush(skillLevel);
		return modelMapper.map(saved, SkillLevelDTO.Info.class);
	}
}
