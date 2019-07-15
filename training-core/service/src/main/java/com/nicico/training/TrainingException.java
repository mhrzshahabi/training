package com.nicico.training;

import com.nicico.copper.core.domain.NICICOException;
import com.nicico.copper.core.util.IErrorCode;
import com.nicico.training.model.EducationLicense;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
public class TrainingException extends NICICOException {

	@Getter
	@RequiredArgsConstructor
	public enum ErrorType implements IErrorCode {
		SkillLevelNotFound(404),
		SkillStandardNotFound(404),
		SkillStandardCategoryNotFound(404),
		SkillStandardSubCategoryNotFound(404),
		SyllabusNotFound(404),
		SkillStandardGroupNotFound(404),
		CourseNotFound(404),
		JobNotFound(404),
		TeacherNotFound(404),
		EquipmentNotFound(404),
		CategoryNotFound(404),
		SubCategoryNotFound(404),
		GoalNotFound(404),
		SkillNotFound(404),
		CompetenceNotFound(404),
		TclassNotFound(404),
		StudentNotFound(404),
		SkillGroupNotFound(404),
		JobCompetenceNotFound(404),
		InstituteNotFound(404),
		EducationLicenseNotFound(404),
		CityNotFound(404),
		StateNotFound(404),
		AddressNotFound(404),
		EducationOrientationNotFound(404),
		EducationMajorNotFound(404),
		EducationLevelNotFound(404), CountryNotFound(404);

		private final Integer httpStatusCode;

		@Override
		public String getName() {
			return name();
		}
	}

	// ------------------------------

	public TrainingException(IErrorCode errorCode) {
		super(errorCode);
	}

	public TrainingException(ErrorType errorCode) {
		this(errorCode, null);
	}

	public TrainingException(ErrorType errorCode, String field) {
		super(errorCode, field);
	}
}
