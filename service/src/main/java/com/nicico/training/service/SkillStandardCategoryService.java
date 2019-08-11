package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SkillStandardCategoryDTO;
import com.nicico.training.iservice.ISkillStandardCategoryService;
import com.nicico.training.model.SkillStandardCategory;
import com.nicico.training.model.SkillStandardSubCategory;
import com.nicico.training.repository.SkillStandardCategoryDAO;
import com.nicico.training.repository.SkillStandardSubCategoryDAO;
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
public class SkillStandardCategoryService implements ISkillStandardCategoryService {

	private final ModelMapper modelMapper;
	private final SkillStandardCategoryDAO skillStandardCategoryDAO;
	private final SkillStandardSubCategoryDAO skillStandardSubCategoryDAO;

	@Transactional(readOnly = true)
	public SkillStandardCategoryDTO.Info get(Long id) {
		final Optional<SkillStandardCategory> sscById = skillStandardCategoryDAO.findById(id);
		final SkillStandardCategory skillStandardCategory = sscById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardCategoryNotFound));

		return modelMapper.map(skillStandardCategory, SkillStandardCategoryDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<SkillStandardCategoryDTO.Info> list() {
		final List<SkillStandardCategory> sscAll = skillStandardCategoryDAO.findAll();

		return modelMapper.map(sscAll, new TypeToken<List<SkillStandardCategoryDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public SkillStandardCategoryDTO.Info create(SkillStandardCategoryDTO.Create request) {
		final SkillStandardCategory skillStandardCategory = modelMapper.map(request, SkillStandardCategory.class);

		return save(skillStandardCategory, request.getSkillStandardSubCategoryIds());
	}

	@Transactional
	@Override
	public SkillStandardCategoryDTO.Info update(Long id, SkillStandardCategoryDTO.Update request) {
		final Optional<SkillStandardCategory> sscById = skillStandardCategoryDAO.findById(id);
		final SkillStandardCategory skillStandardCategory = sscById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardCategoryNotFound));

		SkillStandardCategory updating = new SkillStandardCategory();
		modelMapper.map(skillStandardCategory, updating);
		modelMapper.map(request, updating);

		return save(updating, request.getSkillStandardSubCategoryIds());
	}

	@Transactional
	@Override
	public void delete(Long id) {
		skillStandardCategoryDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(SkillStandardCategoryDTO.Delete request) {
		final List<SkillStandardCategory> sscAllById = skillStandardCategoryDAO.findAllById(request.getIds());

		skillStandardCategoryDAO.deleteAll(sscAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<SkillStandardCategoryDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(skillStandardCategoryDAO, request, skillCategory -> modelMapper.map(skillCategory, SkillStandardCategoryDTO.Info.class));
	}

	// ------------------------------

	private SkillStandardCategoryDTO.Info save(SkillStandardCategory skillStandardCategory, Set<Long> skillStandardSubCategoryIds) {
		final Set<SkillStandardSubCategory> skillStandardSubCategories = new HashSet<>();
		Optional.ofNullable(skillStandardSubCategoryIds)
				.ifPresent(skillStandardSubCategoryIdSet -> skillStandardSubCategoryIdSet
						.forEach(skillStandardId ->
								skillStandardSubCategories.add(skillStandardSubCategoryDAO.findById(skillStandardId)
										.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardSubCategoryNotFound)))
						));
		skillStandardCategory.setSkillStandardSubCategories(skillStandardSubCategories);

		final SkillStandardCategory saved = skillStandardCategoryDAO.saveAndFlush(skillStandardCategory);
		return modelMapper.map(saved, SkillStandardCategoryDTO.Info.class);
	}
}
