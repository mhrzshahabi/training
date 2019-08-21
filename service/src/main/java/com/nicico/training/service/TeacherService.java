package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherService implements ITeacherService {

	private final ModelMapper modelMapper;
	private final TeacherDAO teacherDAO;
	private final CategoryDAO categoryDAO;

	private final EnumsConverter.EGenderConverter eGenderConverter = new EnumsConverter.EGenderConverter();
    private final EnumsConverter.EMarriedConverter eMarriedConverter = new EnumsConverter.EMarriedConverter();
    private final EnumsConverter.EMilitaryConverter eMilitaryConverter = new EnumsConverter.EMilitaryConverter();

    @Value("${nicico.teacher.upload.dir}")
    private String teacherUploadDir;

	@Transactional(readOnly = true)
	@Override
	public TeacherDTO.Info get(Long id) {
		final Optional<Teacher> tById = teacherDAO.findById(id);
		final Teacher teacher = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

		return modelMapper.map(teacher, TeacherDTO.Info.class);
	}

	@Transactional(readOnly = true)
	@Override
	public List<TeacherDTO.Info> list() {
		final List<Teacher> tAll = teacherDAO.findAll();

		return modelMapper.map(tAll, new TypeToken<List<TeacherDTO.Info>>() {
		}.getType());
	}

	@Transactional
	@Override
	public TeacherDTO.Info create(TeacherDTO.Create request) {
		final Teacher teacher = modelMapper.map(request, Teacher.class);
//		if(request.getEMarriedId() != null) {
////			teacher.setEMarried(eMarriedConverter.convertToEntityAttribute(request.getEMarriedId()));
////			teacher.setEMarriedTitleFa(teacher.getEMarried().getTitleFa());
//		}
//		if(request.getEMilitaryId() != null) {
////			 teacher.setEMilitary(eMilitaryConverter.convertToEntityAttribute(request.getEMilitaryId()));
////			 teacher.setEMilitaryTitleFa(teacher.getEMilitary().getTitleFa());
//		}
//		if(request.getEGenderId() != null) {
////			teacher.setEGender(eGenderConverter.convertToEntityAttribute(request.getEGenderId()));
////			teacher.setEGenderTitleFa(teacher.getEGender().getTitleFa());
//		}
//		List<Teacher> teacherList = teacherDAO.findByNationalCode(teacher.getNationalCode());
		List<Teacher> teacherList = null;
		if(teacherList==null || teacherList.size()==0)
			return modelMapper.map(teacherDAO.saveAndFlush(teacher), TeacherDTO.Info.class);
		else
			return null;
	}

	@Transactional
	@Override
	public TeacherDTO.Info update(Long id, TeacherDTO.Update request) {
		final Optional<Teacher> cById = teacherDAO.findById(id);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        Teacher updating = new Teacher();
        modelMapper.map(teacher, updating);
        modelMapper.map(request, updating);
//
//		if(request.getEMarriedId() != null) {
////			updating.setEMarried(eMarriedConverter.convertToEntityAttribute(request.getEMarriedId()));
////			updating.setEMarriedTitleFa(updating.getEMarried().getTitleFa());
//		}
//        if(request.getEMilitaryId() != null) {
////			updating.setEMilitary(eMilitaryConverter.convertToEntityAttribute(request.getEMilitaryId()));
////			updating.setEMilitaryTitleFa(updating.getEMilitary().getTitleFa());
//		}
//        if(request.getEGenderId() != null) {
////			updating.setEGender(eGenderConverter.convertToEntityAttribute(request.getEGenderId()));
////			updating.setEGenderTitleFa(updating.getEGender().getTitleFa());
//		}
////        List<Teacher> teacherList = teacherDAO.findByNationalCode(id,request.getNationalCode());
//		if(teacherList==null || teacherList.size()==0)
//			   return modelMapper.map(teacherDAO.saveAndFlush(updating), TeacherDTO.Info.class);
//		else
			return null;
	}

	@Transactional
	@Override
	public void delete(Long id) {
		teacherDAO.deleteById(id);
	}

	@Transactional
	@Override
	public void delete(TeacherDTO.Delete request) {
		final List<Teacher> tAllById = teacherDAO.findAllById(request.getIds());
		teacherDAO.deleteAll(tAllById);
	}

	@Transactional(readOnly = true)
	@Override
	public SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request) {
		return SearchUtil.search(teacherDAO, request, teacher -> modelMapper.map(teacher, TeacherDTO.Info.class));
	}

	// ------------------------------

	private TeacherDTO.Info save(Teacher teacher) {
		final Teacher saved = teacherDAO.saveAndFlush(teacher);
		return modelMapper.map(saved, TeacherDTO.Info.class);
	}

	@Transactional
    @Override
    public void addCategories(CategoryDTO.Delete request, Long teacherId) {
      	final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));

        Set<Category> currents = teacher.getCategories();
        if(currents != null) {
            Object[] currentsArr = currents.toArray();
            for (Object o : currentsArr) {
                teacher.getCategories().remove(o);
            }
        }

        List<Category> gAllById = categoryDAO.findAllById(request.getIds());
        for (Category category : gAllById) {
            teacher.getCategories().add(category);
        }
    }

    @Transactional
    @Override
    public List<Long> getCategories(Long teacherId) {
      	final Optional<Teacher> cById = teacherDAO.findById(teacherId);
        final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        Set<Category> currents = teacher.getCategories();
        List<Long> categories = new ArrayList<Long>();
        for (Category current : currents) {
            categories.add(current.getId());
        }
        return categories;
    }
}
