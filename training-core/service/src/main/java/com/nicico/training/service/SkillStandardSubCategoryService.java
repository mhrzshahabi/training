package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SkillStandardSubCategoryDTO;
import com.nicico.training.iservice.ISkillStandardSubCategoryService;
import com.nicico.training.model.SkillStandardSubCategory;
import com.nicico.training.repository.SkillStandardSubCategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

//import springfox.documentation.swagger2.mappers.ModelMapper;

@RequiredArgsConstructor
@Service
public class SkillStandardSubCategoryService implements ISkillStandardSubCategoryService {

	private final ModelMapper modelMapper;
	private final SkillStandardSubCategoryDAO skillStandardSubCategoryDAO;

	@Transactional(readOnly = true)
	public SkillStandardSubCategoryDTO.Info get(Long id) {
		final Optional<SkillStandardSubCategory> ssscById = skillStandardSubCategoryDAO.findById(id);
		final SkillStandardSubCategory skillStandardSubCategory = ssscById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardSubCategoryNotFound));

		return modelMapper.map(skillStandardSubCategory, SkillStandardSubCategoryDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<SkillStandardSubCategoryDTO.Info> list() {
		final List<SkillStandardSubCategory> ssscAll = skillStandardSubCategoryDAO.findAll();

		return modelMapper.map(ssscAll, new TypeToken<List<SkillStandardSubCategoryDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public SkillStandardSubCategoryDTO.Info create(SkillStandardSubCategoryDTO.Create request) {
		final SkillStandardSubCategory skillStandardSubCategory = modelMapper.map(request, SkillStandardSubCategory.class);

		return save(skillStandardSubCategory);
	}

	@Transactional
	@Override
	public SkillStandardSubCategoryDTO.Info update(Long id, SkillStandardSubCategoryDTO.Update request) {
		final Optional<SkillStandardSubCategory> ssscById = skillStandardSubCategoryDAO.findById(id);
		final SkillStandardSubCategory skillStandardSubCategory = ssscById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillStandardSubCategoryNotFound));

		SkillStandardSubCategory updating = new SkillStandardSubCategory();
		modelMapper.map(skillStandardSubCategory, updating);
		modelMapper.map(request, updating);

		return save(updating);
	}

	@Transactional
	@Override
	public void delete(Long id) {
		skillStandardSubCategoryDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(SkillStandardSubCategoryDTO.Delete request) {
		final List<SkillStandardSubCategory> ssscAllById = skillStandardSubCategoryDAO.findAllById(request.getIds());

		skillStandardSubCategoryDAO.deleteAll(ssscAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<SkillStandardSubCategoryDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(skillStandardSubCategoryDAO, request, skillWorkSubCategory -> modelMapper.map(skillWorkSubCategory, SkillStandardSubCategoryDTO.Info.class));
	}

	// ------------------------------

	private SkillStandardSubCategoryDTO.Info save(SkillStandardSubCategory skillStandardSubCategory) {
		final SkillStandardSubCategory saved = skillStandardSubCategoryDAO.saveAndFlush(skillStandardSubCategory);
		return modelMapper.map(saved, SkillStandardSubCategoryDTO.Info.class);
	}
}
