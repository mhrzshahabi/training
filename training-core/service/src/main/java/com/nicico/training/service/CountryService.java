package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CountryDTO;
import com.nicico.training.iservice.ICountryService;
import com.nicico.training.model.Country;
import com.nicico.training.repository.CountryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CountryService implements ICountryService {
    private final ModelMapper modelMapper;
    private final CountryDAO countryDAO;

    @Transactional(readOnly = true)
    @Override
    public CountryDTO.Info get(Long id) {
        final Optional<Country> gById = countryDAO.findById(id);
        final Country country = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CountryNotFound));
        return modelMapper.map(country, CountryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CountryDTO.Info> list() {
        final List<Country> gAll = countryDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<CountryDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CountryDTO.Info create(CountryDTO.Create request) {
        final Country country = modelMapper.map(request, Country.class);
        return save(country);
    }

    @Transactional
    @Override
    public CountryDTO.Info update(Long id, CountryDTO.Update request) {
        final Optional<Country> cById = countryDAO.findById(id);
        final Country country = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Country updating = new Country();
        modelMapper.map(country, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Country> one = countryDAO.findById(id);
        final Country country = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        countryDAO.delete(country);
    }

    @Transactional
    @Override
    public void delete(CountryDTO.Delete request) {
        final List<Country> gAllById = countryDAO.findAllById(request.getIds());
        countryDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CountryDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(countryDAO, request, country -> modelMapper.map(country, CountryDTO.Info.class));
    }

    // ------------------------------

    private CountryDTO.Info save(Country country) {
        final Country saved = countryDAO.saveAndFlush(country);
        return modelMapper.map(saved, CountryDTO.Info.class);
    }
}
