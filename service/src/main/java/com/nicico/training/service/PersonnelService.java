/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PostDAO;
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
public class PersonnelService implements IPersonnelService {

    private final PersonnelDAO personnelDAO;
    private final ModelMapper modelMapper;
    private final PostDAO postDAO;

    @Transactional(readOnly = true)
    @Override
    public List<PersonnelDTO.Info> list() {
        return modelMapper.map(personnelDAO.findAll(), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public PersonnelDTO.Info get(String personnelNo) {
        return modelMapper.map(getPersonnel(personnelNo), PersonnelDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Personnel getPersonnel(String personnelNo) {
        Optional<Personnel> optPersonnel = personnelDAO.findById(personnelNo);
        return optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(personnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(personnelDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelDTO.Info.class));
    }

    @Override
    @Transactional
    public List<PersonnelDTO.Info> getByPostCode(Long postId) {

        List<Personnel> personnelDTO = null;

        String postCode = postDAO.findOneById(postId);
        if (((personnelDAO.findOneByPostCode(postCode)) == null)) {
            return null;
        } else {
            if ((personnelDAO.findOneByPostCode(postCode)) == null) {
                return null;
            }

            personnelDTO = personnelDAO.findOneByPostCode(postCode);

        }

        return modelMapper.map(personnelDTO, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

    }

    @Override
    @Transactional(readOnly = true)
    public List<Personnel> getByPostCode(String postCode) {
        return personnelDAO.findOneByPostCode(postCode);
    }

    @Override
    @Transactional
    public List<PersonnelDTO.Info> getByJobNo(String jobNo) {
        List<Personnel> personnelDTO = null;
        if (((personnelDAO.findOneByJobNo(jobNo)) == null)) {
            return null;
        } else {
            personnelDTO = personnelDAO.findOneByJobNo(jobNo);
        }
        return modelMapper.map(personnelDTO, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

    }

    @Override
    @Transactional
    public PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<Personnel> optPersonnel = personnelDAO.findOneByPersonnelNo(personnelCode);
        final Personnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, PersonnelDTO.PersonalityInfo.class);
    }

    @Override
    @Transactional
    public List<PersonnelDTO.Info> findAllStatisticalReportFilter(String reportType) {

        String complexTitle = null, assistant = null, affairs = null, section = null, unit = null;
        List<String> allReportFilter = null;

        switch (reportType) {
            case "complex":
                allReportFilter = personnelDAO.findAllComplexFromPersonnel();
                break;
            case "assistant":
                allReportFilter = personnelDAO.findAllAssistantFromPersonnel();
                break;
            case "affairs":
                allReportFilter = personnelDAO.findAllAffairsFromPersonnel();
                break;
            case "section":
                allReportFilter = personnelDAO.findAllSectionFromPersonnel();
                break;
            case "unit":
                allReportFilter = personnelDAO.findAllUnitFromPersonnel();
                break;
        }

        List<PersonnelDTO.StatisticalReport> listComplex = new ArrayList<>();
        listComplex.add(new PersonnelDTO.StatisticalReport("همه", "همه", "همه", "همه", "همه"));

        for (String filter : allReportFilter) {

            switch (reportType) {
                case "complex":
                    complexTitle = filter;
                    break;
                case "assistant":
                    assistant = filter;
                    break;
                case "affairs":
                    affairs = filter;
                    break;
                case "section":
                    section = filter;
                    break;
                case "unit":
                    unit = filter;
                    break;
            }

            listComplex.add(new PersonnelDTO.StatisticalReport(complexTitle, assistant, affairs, section, unit));
        }

        return modelMapper.map(listComplex, new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
    }

}
